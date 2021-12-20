@r@
identifier OPS;
identifier i2c_probe;
fresh identifier i2c_probe_wrap = "bp_" ## i2c_probe;
position p;
@@
struct i2c_driver OPS@p = {
+#if LINUX_VERSION_IS_GEQ(4,10,0)
	.probe_new = i2c_probe,
+#else
+	.probe = i2c_probe_wrap,
+#endif
};

@@
identifier r.i2c_probe_wrap;
identifier r.i2c_probe;
@@
int i2c_probe(...) {...}
+#if LINUX_VERSION_IS_LESS(4,10,0)
+static int i2c_probe_wrap(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	return i2c_probe(client);
+}
+#endif
