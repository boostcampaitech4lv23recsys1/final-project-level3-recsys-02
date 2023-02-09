import json
import os

from bentoml.exceptions import InvalidArgument
from bentoml.service.artifacts import BentoServiceArtifact
from bentoml.utils import cloudpickle


class MyModelArtifact(BentoServiceArtifact):
    def __init__(self, name):
        super(MyModelArtifact, self).__init__(name)
        self._model = None

    def pack(self, model, metadata=None):
        if isinstance(model, dict) is not True:
            raise InvalidArgument("MyModelArtifact only support dict")
        if model.get("S3Rec", None) is None:
            raise KeyError('"S3Rec" is not available in the model')
        self._model = model
        return self
    
    def get(self):
        return self._model

    def save(self, dst):
        with open(self._file_path(dst), "wb") as file:
            cloudpickle.dump(self._model, file)

    def load(self, path):
        with open(self._file_path(path), "rb") as file:
            model = cloudpickle.load(file)
        return self.pack(model)

    def _file_path(self, base_path):
        return os.path.join(base_path, self.name + ".json")
