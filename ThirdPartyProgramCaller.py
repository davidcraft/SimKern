import os
import subprocess
import csv
from SupportedFileTypes import SupportedFileTypes
import collections
import logging
import numpy as np
from SupportedThirdPartyResponses import SupportedThirdPartyResponses
from MatrixService import MatrixService


class ThirdPartyProgramCaller(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)
    SIM0OUTPUT_FILE_NAME = 'Sim0Output'
    SIM1OUTPUT_FILE_NAME = 'Sim1'
    OUTPUT_FOLDER_NAME = "/SimulationOutputs"

    def __init__(self, files_directory, file_type, file_list, response_type, number_of_genomes, number_of_trials=0):
        self.files_directory = files_directory
        self.file_type = file_type
        self.file_list = file_list
        self.response_type = response_type
        self.counter = 0
        self.number_of_genomes = int(number_of_genomes)
        self.number_of_trials = int(number_of_trials)

    def callThirdPartyProgram(self, should_write_sim0_output):
        current_directory = os.getcwd()
        directory_of_files = self.files_directory + "/GenomeFiles"
        self.changeWorkingDirectory(directory_of_files)
        outputs = collections.OrderedDict()
        if self.file_type == SupportedFileTypes.MATLAB:
            try:
                import matlab.engine
                outputs = self.callMatlabAPI(outputs)
            except ImportError as error:
                self.log.warn("Unable to find MATLAB API hook. Starting program once per trial file.\n%s", error)
                for file in self.file_list:
                    self.log.info(str(100 * self.counter / len(self.file_list)) + "% complete")
                    self.counter = self.counter + 1
                    file_result = self.callMATLAB(directory_of_files, file)
                    outputs[file.split(".")[0]] = file_result
                    if self.number_of_trials != 0:
                        output_file_name = self.SIM1OUTPUT_FILE_NAME + '_' + file.split(".")[0]
                        self.writeOutputFile(file_result, output_file_name)
                        self.writeSim1Matrix(outputs)
        elif self.file_type == SupportedFileTypes.R:
            for file in self.file_list:
                self.log.info(str(100 * self.counter / len(self.file_list)) + "% complete")
                self.counter = self.counter + 1
                file_result = self.callR(directory_of_files, file)
                outputs[file.split(".")[0]] = file_result
                if self.number_of_trials != 0:
                    output_file_name = self.SIM1OUTPUT_FILE_NAME + '_' + file.split(".")[0]
                    self.writeOutputFile(file_result, output_file_name)
                    self.writeSim1Matrix(outputs)
        elif self.file_type == SupportedFileTypes.OCTAVE:
            for file in self.file_list:
                self.log.info(str(100 * self.counter / len(self.file_list)) + "% complete")
                self.counter = self.counter + 1
                file_result = self.callOctave(directory_of_files, file)
                outputs[file.split(".")[0]] = file_result
                if self.number_of_trials != 0:
                    output_file_name = self.SIM1OUTPUT_FILE_NAME + '_' + file.split(".")[0]
                    self.writeOutputFile(file_result, output_file_name)
                    self.writeSim1Matrix(outputs)
        if should_write_sim0_output:
            output_list = []
            for file in outputs.keys():
                output_list.append(outputs[file])
            self.writeOutputFile(output_list, self.SIM0OUTPUT_FILE_NAME)
        elif self.number_of_trials != 0:
            sim1matrix_service = MatrixService(outputs, self.number_of_genomes, self.number_of_trials)
            sim1matrix_service.generateSimilarityMatrix('final')
            if self.response_type == SupportedThirdPartyResponses.FLOAT or self.response_type == SupportedThirdPartyResponses.INTEGER:
                sim1matrix_service.generateResponseMatrix()
        self.changeWorkingDirectory(current_directory)
        return outputs

    def writeOutputFile(self, outputs, output_file_name):
        if type(outputs) != list:
            outputs = [outputs]
        path = os.getcwd()
        self.changeWorkingDirectory(path + self.OUTPUT_FOLDER_NAME)
        file_name = output_file_name + ".csv"
        with open(file_name, 'w') as csv_file:
            try:
                outputs_writer = csv.writer(csv_file)
                outputs_writer.writerow(outputs)
            except ValueError as error:
                self.log.error("Error writing %s to file %s. %s", outputs, file_name, error)
            finally:
                csv_file.close()
                os.chdir(path)

    def callOctave(self, directory_of_file, call_file):
        cmd = 'octave -q ' + directory_of_file + "/" + call_file
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        self.log.info("Output result from file %s: %s", call_file, out)
        output = out.strip()
        output = output.split()
        output = self.reshapeOutput(output)
        return output


    def callMatlabAPI(self, outputs):
        import matlab.engine
        self.log.info('Using the matlab api hook')
        eng = matlab.engine.start_matlab('-nojvm -nodisplay -nosplash -nodesktop')
        for file in self.file_list:
            file_name = file.split(".")[0]
            eng.eval(file_name,nargout=0)
            output = eng.workspace['output']
            outputs[file_name] = output
            self.counter = self.counter + 1
            self.log.info(str(100 * self.counter / len(self.file_list)) + "% complete")
            if self.number_of_trials != 0:
                output_file_name = self.SIM1OUTPUT_FILE_NAME + '_' +file_name
                self.writeOutputFile(output, output_file_name)
                self.writeSim1Matrix(outputs)
        eng.quit()
        return outputs


    def callMATLAB(self, directory_of_file, call_file):
        cmd = 'matlab -nojvm -nodisplay -nosplash -nodesktop <' + directory_of_file + "/" + call_file
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()

        first = out.index("[")
        second = out.index("]")
        self. log.info(str(100 * self.counter / len(self.file_list)) + "% complete")
        self.counter = self.counter + 1
        output = out[first + 1:second]
        output = output.strip()
        output = output.split()
        output = self.reshapeOutput(output)
        return output

    def callR(self, directory_of_file, call_file):
        cmd = 'Rscript ' + directory_of_file + "/" + call_file
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()

        pos = out.index("]")
        output = out[pos + 2]
        self.log.info(output + ": " + str(100 * self.counter / len(self.file_list)) + "% complete")
        self.counter = self.counter + 1
        return int(output)

    def writeSim1Matrix(self, outputs, min_num_of_trials=2):
        current_trials = (self.counter//self.number_of_genomes)
        if (self.counter % (1 * self.number_of_genomes) == 0) and (current_trials > min_num_of_trials):
            sim1matrix_service = MatrixService(outputs, self.number_of_genomes, current_trials)
            self.log.info('Writing similarity matrix based on %s trials.', str(current_trials))
            sim1matrix_service.generateSimilarityMatrix(str(current_trials))

    def changeWorkingDirectory(self, new_directory):
        if not os.path.isdir(new_directory):
            os.mkdir(new_directory)
        os.chdir(new_directory)

    def reshapeOutput(self,output):
        if len(output) == 1:
            try:
                output = int(output[0])
                return output
            except TypeError as type_error:
                self.log.error(type_error)
                return self.response_type(-1)
        else:
            try:
                t = int(output[0])
                n = int(output[1])
                output = output[2:]
                output = [float(i) for i in output]
                assert ((n * t) == len(output))
                response_vector = np.array(output).reshape((t,n))#reconstruct the origianl matrix
                return response_vector
            except TypeError as type_error:
                self.log.error(type_error)
                return []
