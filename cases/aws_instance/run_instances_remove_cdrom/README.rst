run_instance_remove_cdrom
=========================

Summary
-------
This example introduces ``aws_instance`` resource without ``cdrom`` block device.

Differences
-----------

Notes
~~~~~
``root_block_device`` section is required for proper detection of the instance root device. Any additional block devices must be defined in ``ebs_block_device`` section.

Example
-------
.. literalinclude:: main.tf
