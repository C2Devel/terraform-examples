aws_ami
=======

Summary
-------
This example introduces ``aws_ami`` resource.

.. toctree::
   :caption: additional examples

   run_ami_with_tags_filter/README

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``ena_support``
* ``architecture``

Notes
~~~~~

For ``ephemeral_block_device`` block ``cdrom<N>`` and ``floppy<N>`` values are supported for ``device_name`` and ``virtual_name`` attributes.

Special notes
-------------

This resource supports ``tags`` attribute:

Example tag
~~~~~~~~~~~
.. code-block::

   resource "aws_ami" "test_ami_from_snapshot" {
       ...

       tags = {
         Name = "value"
       }
       ...
    }

Example
-------
.. literalinclude:: main.tf
