from memote.suite.cli.reports import diff
import cobra
import os
import logging
from cobra.manipulation.modify import rename_genes
#from concerto.utils.biolog_help import add_biolog_exchanges
from cobra.io import read_sbml_model

log = logging.getLogger()

_file_path = os.getcwd()
starting_model_f_name = 'csc009.xml'
s_model_path = os.path.join(_file_path, starting_model_f_name)

starting_model = cobra.io.read_sbml_model(s_model_path)
starting_model.id = "csc009"

output_model_name = 'updated_csc009.xml'
output_model_path = os.path.join(_file_path, output_model_name)

model = read_sbml_model("csc009.xml")

def write_model(model):
    cobra.io.write_sbml_model(model, output_model_path)


def update_1(model):
    # updates chemical formulas in the model
    log.info("Correcting chemical formulas of metabolites")
    
    metabolites = ["2m35mdntha_e", "35dnta_e", "3h4atb_e"] 
    metabolites_formula = [ "C14H11N5O8", "C14H11N5O8", "C6H9O4S"]
    for i in range(len(metabolites)):
        metabolite_to_change = model.metabolites.get_by_id(metabolites[i])
        metabolite_to_change.formula = metabolites_formula[i]
    return model

def update_model():
    # Updating chemical formulas.
    model = update_1(starting_model)
    write_model(model)


if __name__ == '__main__':
    update_model()
    '''model_paths = [s_model_path, output_model_path]
    diff(
        [
            *model_paths,
            '--filename', os.path.join(_file_path, 'model_differences.html'),
            '--experimental', os.path.join(_file_path, 'data', 'experiments.yml'),
            # '--custom-tests', os.path.join(_file_path, 'custom_tests'),
            '--exclusive', 'test_growth',
        ]
    )'''

