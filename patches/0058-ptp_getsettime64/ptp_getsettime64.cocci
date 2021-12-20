// ----------------------------------------------------------------------------
// handle gettime64 to gettime function assignments
@r1@
expression E1, E2;
@@
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 E1.gettime64 = E2;
+#else
+E1.gettime = E2;
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */

// ----------------------------------------------------------------------------
// handle calls to gettime64 as calls to gettime
@r2@
expression E1, E2, E3;
@@
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 E1.gettime64(E2, E3);
+#else
+E1.gettime(E2, E3);
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */

// ----------------------------------------------------------------------------
// handle settime64 to settime function assignments
@r3@
expression E1, E2;
@@
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 E1.settime64 = E2;
+#else
+E1.settime = E2;
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */

