import os


class OperatingSystemUtil(object):

    @staticmethod
    def changeWorkingDirectory(new_directory):
        if not os.path.isdir(new_directory):
            os.mkdir(new_directory)
        os.chdir(new_directory)

