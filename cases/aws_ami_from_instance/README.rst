aws_ami_from_instance
=====================

Summary
-------
This example introduces ``aws_ami_from_instance`` resource.

Differences
-----------

Unsupported attributes
~~~~~~~~~~~~~~~~~~~~~~

* ``snapshot_without_reboot``

Notes
~~~~~

Current resource cant be created properly. Add custom code to switch instance to ``stopped`` state.

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
