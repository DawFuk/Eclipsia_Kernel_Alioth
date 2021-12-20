@@
identifier ndisc_send_na;
expression netdev, saddr, target, router, solicited, override, inc_opt;
@@
+#if LINUX_VERSION_IS_GEQ(4,4,0)
 ipv6_stub->ndisc_send_na(netdev, saddr, target, router, solicited, override, inc_opt);
+#else
+ipv6_stub->ndisc_send_na(netdev, NULL, saddr, target, router, solicited, override, inc_opt);
+#endif
