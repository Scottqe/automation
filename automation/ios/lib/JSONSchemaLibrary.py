
from robot.api import logger
import json
import jsonref
import jsonschema
import os


class JSONSchemaLibrary:

    def __init__(self):
        self.cwd = os.path.abspath(os.path.join(
            os.path.dirname(os.path.abspath(__file__)), os.pardir))
        self.schema_location = self.cwd + '/res/schema'

    def _load_json_schema(self, filename):
        """ Loads the given schema file """
        absolute_path = '{}/{}'.format(self.schema_location, filename)
        base_uri = 'file://{}/'.format(absolute_path)
        with open(absolute_path) as schema_file:
            schemas_file = schema_file.read()
            return jsonref.loads(schemas_file, base_uri=base_uri, jsonschema=True)

    def verify_schema(self, schema_filename, schema_name, sample):
        """Validates the sample JSON against the given schema."""
        schema = self._load_json_schema(schema_filename)
        schema = schema[schema_name]
        try:
            jsonschema.validate(sample, schema)
        except jsonschema.ValidationError as e:
            logger.debug(e)
            print(sample)
            raise jsonschema.ValidationError(
                'Validation error for schema {}: {}'.format(schema_name, e.message))