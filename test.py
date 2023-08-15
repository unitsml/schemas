import unittest
import xmlschema

class Test_UnitsXML(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls._schema = xmlschema.XMLSchema11('./unitsml/unitsml-v2.0.xsd')
    def test_valid_full_instance(self):
        try:
            self._schema.validate('./tests/valid.xml')
        except Exception as e:
            self.fail("Invalid.")
    def test_duplicate_regulatoryBody(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/regulatoryBody_duplicate.xml')
    def test_invalid_unitset_domain(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unitset_invalid_domain.xml')
    def test_invalid_unitset_domain_conflict(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unitset_conflicting_domain.xml')

    def test_invalid_unique_unit(self): 
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unique_unit.xml')
    def test_invalid_unit_domain(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_invalid_NMI.xml')
    def test_unit_partial_composite_key(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_partial_composite_key.xml')
    def test_unit_partial_composite_key_version(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_partial_composite_key_version.xml')
    def test_unit_invalid_root_unit_prefix_reference(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_invalid_root_unit_prefix_reference.xml')
    def test_unit_invalid_root_unit_unit_reference_in_prefix_ref(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_invalid_root_unit_unit_reference_in_prefix_ref.xml')
    def test_unit_invalid_root_unit_unit_reference(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_invalid_root_unit_unit_reference.xml')
    def test_unit_invalid_quantity_reference(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_invalid_quantity_reference.xml')
    def test_invalid_unit_previousVersion(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_previousVersion.xml')
    def test_unit_version_predates_ancestor(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_version_predates_ancestor.xml')
    def test_unit_too_high_initial_version(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_too_high_initial_version.xml')
    def test_invalid_unit_DSI(self):
        with self.assertRaises(xmlschema.validators.exceptions.XMLSchemaValidationError):
            self._schema.validate('./tests/unit_D-SI.xml')
    
if __name__ == '__main__':
    unittest.main()