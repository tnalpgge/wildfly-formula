wildfly-formula
===============

Wildfly is a Java application server.  https://wildfly.org/about/

Available States
----------------

.. contents::
    :local:

``wildfly``
^^^^^^^^^^^

Ensures Wildfly is installed and running.

``wildfly.absent``
^^^^^^^^^^^^^^^^^^

Ensures Wildfly is stopped and removed from the system.

Example pillar configuration
----------------------------

.. code-block:: yaml

    wildfly:
      lookup:

Additional resources
--------------------

http://wildfly.org/
