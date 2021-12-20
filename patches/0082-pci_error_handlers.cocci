@r@
identifier OPS;
identifier pcie_reset_prepare_fn;
identifier pcie_reset_done_fn;
fresh identifier pcie_reset_notify_fn = pcie_reset_prepare_fn ## "_notify";
position p;
@@
struct pci_error_handlers OPS@p = {
+#if LINUX_VERSION_IS_GEQ(4,13,0)
	.reset_prepare = pcie_reset_prepare_fn,
	.reset_done = pcie_reset_done_fn,
+#else
+	.reset_notify = pcie_reset_notify_fn,
+#endif
};


@@
identifier r.pcie_reset_prepare_fn;
identifier r.pcie_reset_done_fn;
identifier r.pcie_reset_notify_fn;
@@
void pcie_reset_done_fn(...) {...}
+#if LINUX_VERSION_IS_LESS(4,13,0)
+static void pcie_reset_notify_fn(struct pci_dev *dev, bool prepare)
+{
+	if (prepare)
+		pcie_reset_prepare_fn(dev);
+	else
+		pcie_reset_done_fn(dev);
+}
+#endif
