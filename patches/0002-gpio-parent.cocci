/* convert gpio: change member .dev to .parent
 *
 * add semantic patch which uses the dev member of struct gpio_chip on
 * kenrel version < 4.5 This change was done in upstream kernel commit
 * 58383c78 "gpio: change member .dev to .parent".
 */

@r1@
struct gpio_chip *chip;
expression E1;
@@
+#if LINUX_VERSION_IS_GEQ(4,5,0)
 chip->parent = E1;
+#else
+chip->dev = E1;
+#endif /* LINUX_VERSION_IS_GEQ(4,5,0) */
@r2@
struct gpio_chip chip;
expression E2;
@@
+#if LINUX_VERSION_IS_GEQ(4,5,0)
 chip.parent = E2;
+#else
+chip.dev = E2;
+#endif /* LINUX_VERSION_IS_GEQ(4,5,0) */
