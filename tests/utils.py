"""Utilities"""

import os


class Directory(str):
    """Automatically create directory structures"""

    def __new__(cls, path):
        """Str immutable types call __new__() to instantiate new classes.

        Create directory when directory class is created"""

        if not os.path.isdir(path):
            os.makedirs(path)

        return str.__new__(cls, path)

    def subdir(self, directory):
        """Return Directory object to subdirectory `<self>/<directory>

        :directory: Subdirectory name
        :returns: Directory object to subdirectory

        """
        return Directory(os.path.join(self, directory))

    def __getattr__(self, attr):
        """Return original class attribute ethods or self.subdir(attr) if
        attribute does not exist.

        :attr: Attribute
        :returns: Attribute or Directory object

        """

        try:
            if attr in self.__dict__:
                return self.__dict__[attr]
            return self.subdir(attr)
        except Exception as exception:
            raise AttributeError(str(exception))
