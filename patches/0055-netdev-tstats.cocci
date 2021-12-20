@@
struct net_device *dev;
expression E;
@@
-dev->tstats = E;
+netdev_assign_tstats(dev, E);
@@
struct net_device *dev;
@@
-dev->tstats
+netdev_tstats(dev)
