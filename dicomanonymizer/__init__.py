import importlib.metadata

from dicomanonymizer.anonymizer import anonymize
from dicomanonymizer.simpledicomanonymizer import *  # noqa


__version__ = importlib.metadata.version("dicom-anon")


__all__ = [
    "__version__",
    "anonymize",
]
