@r1@
expression E1,E2;
struct sk_buff *skb;
@@
+#if LINUX_VERSION_IS_GEQ(3,18,0)
 E1 ^= E2(..., skb->no_fcs, ...)
+#endif /* if LINUX_VERSION_IS_GEQ(3,18,0) */
