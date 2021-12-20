@r1@
struct page *page;
expression E1;
@@
 return E1
+#if LINUX_VERSION_IS_GEQ(3,6,0)
 || page_is_pfmemalloc(page)
+#endif /* if LINUX_VERSION_IS_GEQ(3,6,0) */
 ;
