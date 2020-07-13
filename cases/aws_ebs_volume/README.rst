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

``gp2`` and ``st2`` are valid values for ``type`` attribute.  ``iops = "400"`` is the only possible iops specification for disks with ``st2`` volume type. Disks with ``st2`` volume type must have ``size`` attribute value more then ``32G`` and be multiple of 8GiB. The volume size for ``gp2`` volume type varies from 8 GiB to 4 TiB. The volume size must be multiple of 8 GiB. For more information visit documentation `page <https://docs.cloud.croc.ru/en/services/instances_and_volumes/volumes.html>`_.

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
