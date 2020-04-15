aws_ebs_volume
==============

Summary
-------
This example introduces ``aws_ebs_volume`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``encrypted``
* ``kms_key_id``

Notes
~~~~~

``io1`` and ``st2`` are valid values for ``type`` attribute. ``iops = "400"`` is the only possible iops specification for disks with ``st2`` volume type. Disks with ``st2`` volume type must have ``size`` attribute value more then ``32G``.

Special notes
-------------

This resource supports ``tags`` attribute:

Example tag
~~~~~~~~~~~
.. code-block::

   resource "aws_ebs_volume" "test_volume_iops" {
       ...

       tags = {
         Name = "value"
       }
       ...
    }

Example
-------
.. literalinclude:: main.tf