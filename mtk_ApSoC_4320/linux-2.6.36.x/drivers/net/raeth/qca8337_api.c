/*  Copyright(c) 2003-2017 Shenzhen TP-LINK Technologies Co.Ltd.
 *
 * file		qca8337_api.c
 * brief		
 * details	
 *
 * author		WANG Wenhu
 * version	
 * date		Dec31th 2016
 *
 * history 	\arg	
 */
 
#include "qca8337_api.h"
#include "rt_mmap.h"
#include <linux/byteorder/little_endian.h>
#include <linux/delay.h>
/**************************************************************************************************/
/*                                           DEFINES                                              */
/**************************************************************************************************/

/**************************************************************************************************/
/*                                           TYPES                                                */
/**************************************************************************************************/


/**************************************************************************************************/
/*                                           EXTERN_PROTOTYPES                                    */
/**************************************************************************************************/
extern int mii_mgr_read(u_int32_t phy_addr, u_int32_t phy_register, u_int32_t *read_data);
extern int mii_mgr_write(u_int32_t phy_addr, u_int32_t phy_register, u_int32_t write_data);

/**************************************************************************************************/
/*                                           LOCAL_PROTOTYPES                                     */
/**************************************************************************************************/

/**************************************************************************************************/
/*                                           VARIABLES                                            */
/**************************************************************************************************/

/**************************************************************************************************/
/*                                           LOCAL_FUNCTIONS                                      */
/**************************************************************************************************/


/**************************************************************************************************/
/*                                           PUBLIC_FUNCTIONS                                     */
/**************************************************************************************************/



u_int32_t qca8337_read_register(u_int32_t reg, u_int32_t* data)
{
	u_int32_t hdata = 0;
	u_int32_t ldata = 0;
	
	mii_mgr_write(QCA_WRITE_HIGH_ADDR_MDIO_PHY_ADDR, QCA_WRITE_HIGH_ADDR_MDIO_REG_ADDR, QCA_REG_OFFSET_TO_MDIO_DATA(reg));
	mii_mgr_read(QCA_REG_OFFSET_TO_MDIO_PHY_ADDR(reg), QCA_REG_OFFSET_TO_MDIO_REG_ADDR_HIGH(reg), &hdata);
	mii_mgr_read(QCA_REG_OFFSET_TO_MDIO_PHY_ADDR(reg), QCA_REG_OFFSET_TO_MDIO_REG_ADDR_LOW(reg), &ldata);
	
	*data = (hdata << 16) | ldata;
}

u_int32_t qca8337_write_register(u_int32_t reg, u_int32_t data)
{
	u_int32_t hdata = 0;
	u_int32_t ldata = 0;
	
	hdata = (data & 0xffff0000) >> 16;
	ldata = data & 0xffff;
	
	mii_mgr_write(QCA_WRITE_HIGH_ADDR_MDIO_PHY_ADDR, QCA_WRITE_HIGH_ADDR_MDIO_REG_ADDR, QCA_REG_OFFSET_TO_MDIO_DATA(reg));
	mii_mgr_write(QCA_REG_OFFSET_TO_MDIO_PHY_ADDR(reg), QCA_REG_OFFSET_TO_MDIO_REG_ADDR_HIGH(reg), hdata);
	mii_mgr_write(QCA_REG_OFFSET_TO_MDIO_PHY_ADDR(reg), QCA_REG_OFFSET_TO_MDIO_REG_ADDR_LOW(reg), ldata);
}

void qca8337_vlan_config()
{
	qca8337_write_register(S17_P0LOOKUP_CTRL_REG, 0x0014001e);
	qca8337_write_register(S17_P0VLAN_CTRL0_REG, 0x10001);

	qca8337_write_register(S17_P1LOOKUP_CTRL_REG, 0x0014001d);
	qca8337_write_register(S17_P1VLAN_CTRL0_REG, 0x10001);

	qca8337_write_register(S17_P2LOOKUP_CTRL_REG, 0x0014001b);
	qca8337_write_register(S17_P2VLAN_CTRL0_REG, 0x10001);

	qca8337_write_register(S17_P3LOOKUP_CTRL_REG, 0x00140017);
	qca8337_write_register(S17_P3VLAN_CTRL0_REG, 0x10001);

	qca8337_write_register(S17_P4LOOKUP_CTRL_REG, 0x0014000f);
	qca8337_write_register(S17_P4VLAN_CTRL0_REG, 0x10001);

	qca8337_write_register(S17_P5LOOKUP_CTRL_REG, 0x00140040);
	qca8337_write_register(S17_P5VLAN_CTRL0_REG, 0x20001);

	qca8337_write_register(S17_P6LOOKUP_CTRL_REG, 0x00140020);
	qca8337_write_register(S17_P6VLAN_CTRL0_REG, 0x20001);

}

void qca8337_reset()
{
	u_int32_t gpiomode;
	u_int32_t tmp = 0;
	
	/* GPIO Mode */
	gpiomode = le32_to_cpu(*(volatile u_int32_t *)(RALINK_SYSCTL_BASE + 0x60));
	gpiomode |= (0x1 << 15);
	*(volatile u_int32_t *)(RALINK_SYSCTL_BASE + 0x60) = cpu_to_le32(gpiomode);

	/* RALINK_REG_PIO7140DIR for GPIO 40~71 */
	tmp = le32_to_cpu(*(volatile u_int32_t *)(RALINK_PIO_BASE + 0x74));
	tmp |= (1 << (41-40));
	*(volatile u_int32_t *)(RALINK_PIO_BASE + 0x74) = tmp;

	tmp = le32_to_cpu(*(volatile u_int32_t *)(RALINK_PIO_BASE + 0x70));
	tmp &= ~(1 << (41 - 40));
	*(volatile u_int32_t *)(RALINK_PIO_BASE + 0x70) = tmp;
	
	udelay (1000 * 12);

	tmp = le32_to_cpu(*(volatile u_int32_t *)(RALINK_PIO_BASE + 0x70));
	tmp |= (1 << (41 - 40));
	*(volatile u_int32_t *)(RALINK_PIO_BASE + 0x70) = tmp;
}

void qca8337_init()
{
	qca8337_reset();
	
	qca8337_write_register(S17_P5PAD_MODE_REG, REG_VALUE_EN);
	qca8337_write_register(S17_P5STATUS_REG, S17_PORT_STATUS_AZ_DEFAULT);
	
	qca8337_write_register(S17_P0PAD_MODE_REG, REG_VALUE_EN);
	qca8337_write_register(S17_P0STATUS_REG, S17_PORT_STATUS_AZ_DEFAULT);
	
	qca8337_write_register(S17_GLOFW_CTRL1_REG,	0x7f7f7f7f);
}

/**************************************************************************************************/
/*                                           GLOBAL_FUNCTIONS                                     */
/**************************************************************************************************/

