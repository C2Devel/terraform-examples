aws_key_pair
============

Summary
-------
This example introduces ``aws_key_pair`` resource.

Special notes
-------------

This resource supports ``tags`` attribute:

Example tag
~~~~~~~~~~~
.. code-block::

   resource "aws_key_pair" "test_key_pair" {
       ...

       tags = {
         Name = "value"
       }
       ...
    }

Example
-------
.. literalinclude:: main.tf
