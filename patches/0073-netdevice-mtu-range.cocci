@initialize:python@
@@

first_ops = 0

@both@
expression ndevexp;
constant e1, e2;
identifier func;
position p;
@@
func(...) {
	<+...
	ndevexp->min_mtu = e1;
	ndevexp->max_mtu@p = e2;
	...+>
}

@@
expression ndevexp;
constant MAX;
identifier func;
position p != both.p;
@@
func(...) {
	<+...
+	ndevexp->min_mtu = 0;
	ndevexp->max_mtu@p = MAX;
	...+>
}

@r@
identifier OPS;
position p;
@@

struct net_device_ops OPS@p = { ... };

@script:python depends on r@
@@

first_ops = 0

@script:python@
p << r.p;
@@

ln = int(p[0].line)
if first_ops == 0 or ln < first_ops:
  first_ops = ln

@script:python@
p << r.p;
@@

ln = int(p[0].line)
if not(first_ops == ln):
  cocci.include_match(False)

@r1 exists@
expression ndevexp;
constant e1, e2;
identifier func;
@@
func(...) {
	<+...
	ndevexp->min_mtu = e1;
	ndevexp->max_mtu = e2;
	...+>
}

@r2@
constant r1.e1,r1.e2;
identifier r.OPS;
@@
+#if LINUX_VERSION_IS_LESS(4,10,0)
+ static int __change_mtu(struct net_device *ndev, int new_mtu)
+ {
+ if (new_mtu < e1 || new_mtu > e2)
+             return -EINVAL;
+             ndev->mtu = new_mtu;
+             return 0;
+ }
+#endif
+
struct net_device_ops OPS = {
       ...
};

@depends on r2@
identifier OPS;
@@

struct net_device_ops OPS = {
+#if LINUX_VERSION_IS_LESS(4,10,0)
+      .ndo_change_mtu = __change_mtu,
+#endif
       ...
};

