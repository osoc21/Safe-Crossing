
#!/usr/bin/env python

from sys import argv

from time import sleep

import json

from pypozyx import (PozyxConstants, Coordinates, POZYX_SUCCESS, PozyxRegisters, version,
                     DeviceCoordinates, PozyxSerial, get_first_pozyx_serial_port, SingleRegister)
from pythonosc.udp_client import SimpleUDPClient

from pypozyx.tools.version_check import perform_latest_version_check


class TrafficLight:
    def __init__(self, id, x, y):
        self.id = id
        self.x = x
        self.y = y


class PozyxLocalize(object):
    """Continuously performs multitag positioning"""

    def __init__(self, pozyx, osc_udp_client, pozyx_info_file, algorithm=PozyxConstants.POSITIONING_ALGORITHM_UWB_ONLY,
                 dimension=PozyxConstants.DIMENSION_3D, height=1000):
        self.pozyx = pozyx
        self.osc_udp_client = osc_udp_client

        self.TRAFFIC_LIGHT_RADIUS = 400  # in mm

        self.pozyx_info_file = pozyx_info_file
        self.tag_ids = [None, 0x6740]
        self.anchors = []
        self.traffic_lights = []
        self.algorithm = algorithm
        self.dimension = dimension
        self.height = height

    def setup(self):
        """Sets up the Pozyx for positioning by calibrating its anchor list."""
        anchor_ids = [0x672F, 0x6E2F, 0x6706, 0x6762]
        try:
            with open(self.pozyx_info_file) as json_file:
                data = json.load(json_file)

                for anchor in data['anchors']:
                    self.anchors.append(DeviceCoordinates(
                        anchor_ids.pop(),
                        1,
                        Coordinates(anchor['anchorPos']['x'], anchor['anchorPos']['y'], anchor['anchorPos']['z'])))

                # for tag in data['tags']:
                #     self.tag_ids.append(hex(int(tag['id'], 16)))

                for traffic_light in data['trafficLights']:
                    self.traffic_lights.append(TrafficLight(
                        traffic_light['id'], traffic_light['pos']['x'], traffic_light['pos']['y']))
        except:
            # print("Bad file format.")
            quit()

        # print(self.anchors)
        # print()
        # print(self.tag_ids)
        # print()
        # print(self.traffic_lights)

        # print("------------POZYX MULTITAG POSITIONING V{} -------------".format(version))
        # print("")
        # print(" - System will manually calibrate the tags")
        # print("")
        # print(" - System will then auto start positioning")
        # print("")
        if None in self.tag_ids:
            for device_id in self.tag_ids:
                self.pozyx.printDeviceInfo(device_id)
        else:
            for device_id in [None] + self.tag_ids:
                self.pozyx.printDeviceInfo(device_id)
        # print("")
        # print("------------POZYX MULTITAG POSITIONING V{} -------------".format(version))
        # print("")

        self.setAnchorsManual(save_to_flash=False)

        self.printPublishAnchorConfiguration()

    def loop(self):
        """Performs positioning and prints the results."""
        for tag_id in self.tag_ids:
            position = Coordinates()
            status = self.pozyx.doPositioning(
                position, self.dimension, self.height, self.algorithm, remote_id=tag_id)
            if status == POZYX_SUCCESS:
                optional_traffic_light_id = self.check_proximity(position)

                if optional_traffic_light_id != None:
                    print(optional_traffic_light_id)
                print("Null")
                # self.printPublishPosition(position, tag_id)
                sleep(0.3)

    def check_proximity(self, tag_position):
        """Checks if a tag is in radius of a traffic light and if it's the case, returns the id of that traffic light"""

        for traffic_light in self.traffic_lights:
            if (
                (tag_position.x - traffic_light.x) * (tag_position.x - traffic_light.x) +
                (tag_position.y - traffic_light.y) * (tag_position.y - traffic_light.y) <=
                self.TRAFFIC_LIGHT_RADIUS * self.TRAFFIC_LIGHT_RADIUS
            ):
                return traffic_light.id

        return None

    def printPublishPosition(self, position, network_id):
        """Prints the Pozyx's position and possibly sends it as a OSC packet"""
        if network_id is None:
            network_id = 0
        s = "POS ID: {}, x(mm): {}, y(mm): {}, z(mm): {}".format("0x%0.4x" % network_id,
                                                                 position.x, position.y, position.z)
        # print(s)
        if self.osc_udp_client is not None:
            self.osc_udp_client.send_message(
                "/position", [network_id, position.x, position.y, position.z])

    def setAnchorsManual(self, save_to_flash=False):
        """Adds the manually measured anchors to the Pozyx's device list one for one."""
        for tag_id in self.tag_ids:
            status = self.pozyx.clearDevices(tag_id)
            for anchor in self.anchors:
                status &= self.pozyx.addDevice(anchor, tag_id)
            if len(self.anchors) > 4:
                status &= self.pozyx.setSelectionOfAnchors(PozyxConstants.ANCHOR_SELECT_AUTO, len(self.anchors),
                                                           remote_id=tag_id)
            # enable these if you want to save the configuration to the devices.
            if save_to_flash:
                self.pozyx.saveAnchorIds(tag_id)
                self.pozyx.saveRegisters(
                    [PozyxRegisters.POSITIONING_NUMBER_OF_ANCHORS], tag_id)

            self.printPublishConfigurationResult(status, tag_id)

    def printPublishConfigurationResult(self, status, tag_id):
        """Prints the configuration explicit result, prints and publishes error if one occurs"""
        if tag_id is None:
            tag_id = 0
        # if status == POZYX_SUCCESS:
        #     print("Configuration of tag %s: success" % tag_id)
        # else:
        #     self.printPublishErrorCode("configuration", tag_id)

    def printPublishErrorCode(self, operation, network_id):
        """Prints the Pozyx's error and possibly sends it as a OSC packet"""
        error_code = SingleRegister()
        status = self.pozyx.getErrorCode(error_code, network_id)
        if network_id is None:
            network_id = 0
        if status == POZYX_SUCCESS:
            # print("Error %s on ID %s, %s" %
            #   (operation, "0x%0.4x" % network_id, self.pozyx.getErrorMessage(error_code)))
            if self.osc_udp_client is not None:
                self.osc_udp_client.send_message(
                    "/error_%s" % operation, [network_id, error_code[0]])
        else:
            # should only happen when not being able to communicate with a remote Pozyx.
            self.pozyx.getErrorCode(error_code)
            # print("Error % s, local error code %s" %
            #   (operation, str(error_code)))
            if self.osc_udp_client is not None:
                self.osc_udp_client.send_message(
                    "/error_%s" % operation, [0, error_code[0]])

    def printPublishAnchorConfiguration(self):
        for anchor in self.anchors:
            # print("ANCHOR,0x%0.4x,%s" % (anchor.network_id, str(anchor.pos)))
            if self.osc_udp_client is not None:
                self.osc_udp_client.send_message(
                    "/anchor", [anchor.network_id, anchor.pos.x, anchor.pos.y, anchor.pos.z])
                sleep(0.025)


if __name__ == "__main__":
    if len(argv) != 2:
        # print("Pozyx kit info file name not found in command line args.")
        quit()

    # with open(argv[1]) as json_file:
    #     data = json.load(json_file)

    #     for anchor in data['anchors']:
    #         print(anchor)

    # Check for the latest PyPozyx version. Skip if this takes too long or is not needed by setting to False.
    check_pypozyx_version = True
    if check_pypozyx_version:
        perform_latest_version_check()

    # shortcut to not have to find out the port yourself.
    serial_port = get_first_pozyx_serial_port()
    if serial_port is None:
        # print("No Pozyx connected. Check your USB cable or your driver!")
        quit()

    # enable to send position data through OSC
    use_processing = True

    # configure if you want to route OSC to outside your localhost. Networking knowledge is required.
    ip = "127.0.0.1"
    network_port = 8888

    # positioning algorithm to use, other is PozyxConstants.POSITIONING_ALGORITHM_TRACKING
    algorithm = PozyxConstants.POSITIONING_ALGORITHM_UWB_ONLY
    # algorithm = PozyxConstants.POSITIONING_ALGORITHM_TRACKING
    # positioning dimension. Others are PozyxConstants.DIMENSION_2D, PozyxConstants.DIMENSION_2_5D
    dimension = PozyxConstants.DIMENSION_3D
    # dimension = PozyxConstants.DIMENSION_2_5D
    # dimension = PozyxConstants.DIMENSION_2D
    # height of device, required in 2.5D positioning
    height = 500

    # osc_udp_client = None
    if use_processing:
        osc_udp_client = SimpleUDPClient(ip, network_port)

    pozyx = PozyxSerial(serial_port)

    r = PozyxLocalize(pozyx, osc_udp_client,
                      argv[1], algorithm, dimension, height)
    r.setup()
    while True:
        r.loop()
