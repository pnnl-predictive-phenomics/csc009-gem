import cobra
import pathlib
import pandas as pd


path = pathlib.Path(__file__).parent

model = cobra.io.read_sbml_model(
    path.joinpath('csc009\model.xml').__str__()
)

exp_file_path = path.joinpath('data', 'experiments.yml').__str__()
expected_metab = pd.read_csv(
    path.joinpath('data', 'excreted', 'excreted_metab.csv').__str__(),
    index_col=0,
).bigg_id
