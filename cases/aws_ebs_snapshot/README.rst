aws_ebs_snapshot
================

Summary
-------
This example introduces ``aws_ebs_snapshot`` resource.

Special notes
-------------

This resource supports ``tags`` attribute:

Example tag
~~~~~~~~~~~
.. code-block::

   resource "aws_ebs_snapshot" "test_snapshot" {
       ...

       tags = {
         Name = "value"
       }
       ...
    }

Example
-------
.. literalinclude:: main.tf
