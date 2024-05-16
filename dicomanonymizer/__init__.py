import importlib.metadata
from .anonymizer import anonymize_dataset


__version__ = importlib.metadata.version("dicom-anon")


__all__ = [
    "__version__",
    "anonymize_dataset",
]
