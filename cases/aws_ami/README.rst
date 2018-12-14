aws_ami
=======

Summary
-------
This example introduces ``aws_ami`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``ena_support``
* ``architecture``

Notes
~~~~~

For ``ephemeral_block_device`` block ``cdrom<N>`` and ``floppy<N>`` values are supported for ``device_name`` and ``virtual_name`` attributes.

Example
-------
.. literalinclude:: main.tf
