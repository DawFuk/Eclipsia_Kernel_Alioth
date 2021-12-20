@ r1 @
struct phy_device *phydev;
@@
-phydev->mdio.addr
+phydev_get_addr(phydev)
