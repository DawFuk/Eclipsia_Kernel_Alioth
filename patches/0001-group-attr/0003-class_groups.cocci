/* see upstream commit ced6473e74867 */

@ attribute_group @
identifier group;
declarer name ATTRIBUTE_GROUPS;
@@

ATTRIBUTE_GROUPS(group);

@script:python attribute_groups_name@
group << attribute_group.group;
groups;
@@
coccinelle.groups = group + "_groups"

@ class_group @
identifier group_class;
identifier attribute_groups_name.groups;
fresh identifier group_dev_attr = attribute_group.group ## "_dev_attrs";
@@

struct class group_class = {
+#if LINUX_VERSION_IS_GEQ(4,10,0)
	.class_groups = groups,
+#else
+	.class_attrs = group_dev_attr,
+#endif
};

@ attribute_group_mod depends on class_group @
declarer name ATTRIBUTE_GROUPS_BACKPORT;
identifier attribute_group.group;
@@

+#if LINUX_VERSION_IS_GEQ(4,10,0)
ATTRIBUTE_GROUPS(group);
+#else
+#define BP_ATTR_GRP_STRUCT class_attribute
+ATTRIBUTE_GROUPS_BACKPORT(group);
+#endif

@ class_registering @
identifier class_register, ret;
identifier class_group.group_class;
fresh identifier group_class_init = "init_" ## attribute_group.group ## "_attrs";
@@

(
+	group_class_init();
	return class_register(&group_class);
|
+	group_class_init();
	ret = class_register(&group_class);
)
