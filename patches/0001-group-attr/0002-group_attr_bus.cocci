/*
The new attribute sysfs group was added onto struct bus_type via
commit fa6fdb33b

mcgrof@ergon ~/linux (git::master)$ git describe --contains fa6fdb33b
v3.12-rc1~184^2~89

This backport makes use of the helpers to backport this more efficiently.
Refer to the INFO file for documentation there on that.

commit fa6fdb33b486a8afc5439c504da8d581e142c77d
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu Aug 8 15:22:55 2013 -0700

    driver core: bus_type: add dev_groups

    attribute groups are much more flexible than just a list of attributes,
    due to their support for visibility of the attributes, and binary
    attributes. Add dev_groups to struct bus_type which should be used
    instead of dev_attrs.

    dev_attrs will be removed from the structure soon.

    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
*/

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

@ bus_group @
identifier group_bus;
identifier attribute_groups_name.groups;
fresh identifier group_dev_attr = attribute_group.group ## "_dev_attrs";
@@

struct bus_type group_bus = {
+#if LINUX_VERSION_IS_GEQ(3,12,0)
	.dev_groups = groups,
+#else
+	.dev_attrs = group_dev_attr,
+#endif
};

@ attribute_group_mod depends on bus_group @
declarer name ATTRIBUTE_GROUPS_BACKPORT;
identifier attribute_group.group;
@@

+#if LINUX_VERSION_IS_GEQ(3,12,0)
ATTRIBUTE_GROUPS(group);
+#else
+#define BP_ATTR_GRP_STRUCT device_attribute
+ATTRIBUTE_GROUPS_BACKPORT(group);
+#endif

@ bus_registering @
identifier bus_register, ret;
identifier bus_group.group_bus;
fresh identifier group_bus_init = "init_" ## attribute_group.group ## "_attrs";
@@

(
+       group_bus_init();
        return bus_register(&group_bus);
|
+       group_bus_init();
        ret = bus_register(&group_bus);
)
