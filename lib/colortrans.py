#! /usr/bin/env python3

"""
Converts between RGB (8bpp) and PALETTE 256 color (approx 2bpp + 24 grays)
"""

import sys

__author__    = 'Gabriel T. Sharp (osirisgothra@hotmail.com)'
__copyright__ = '(C)Copyright 2015-2016 Gabriel Thomas Sharp, All Rights Reserved'
__license__   = 'Licensed under GNU GPL3 (http://gpl.gnu.org/)'
__version__   = '1.0.2016.1'


	# ANSI STANDARD COLORS (8 and 16 color)

	# (there is also LOWLIGHT but they are not assignable and usually not supported)
	# ANSI NORMAL        HIGHLIGHT           	
    
_T=[('00','000000'), ('08','404040'),
    ('01','800000'), ('09','FF0000'),
    ('02','008000'), ('10','00FF00'),
    ('03','808040'), ('11','FFFF00'),
    ('04','000080'), ('12','0000FF'),
    ('05','800080'), ('13','FF00FF'),
    ('06','008080'), ('14','00FFFF'),
    ('07','A0A0A0'), ('15','FFFFFF'),
   
    # ANSI 88 & 256-color range
    # color 16 counts as the first in the range of 24 grays

    ('16','000000'),
    ('17','00005F'),
    ('18','000087'),
    ('19','0000AF'),
    ('20','0000D7'),
    ('21','0000FF'),
    ('22','005F00'),
    ('23','005F5F'),
    ('24','005F87'),
    ('25','005FAF'),
    ('26','005FD7'),
    ('27','005FFF'),
    ('28','008700'),
    ('29','00875F'),
    ('30','008787'),
    ('31','0087AF'),
    ('32','0087D7'),
    ('33','0087FF'),
    ('34','00AF00'),
    ('35','00AF5F'),
    ('36','00AF87'),
    ('37','00AFAF'),
    ('38','00AFD7'),
    ('39','00AFFF'),
    ('40','00D700'),
    ('41','00D75F'),
    ('42','00D787'),
    ('43','00D7AF'),
    ('44','00D7D7'),
    ('45','00D7FF'),
    ('46','00FF00'),
    ('47','00FF5F'),
    ('48','00FF87'),
    ('49','00FFAF'),
    ('50','00FFD7'),
    ('51','00FFFF'),
    ('52','5F0000'),
    ('53','5F005F'),
    ('54','5F0087'),
    ('55','5F00AF'),
    ('56','5F00D7'),
    ('57','5F00FF'),
    ('58','5F5F00'),
    ('59','5F5F5F'),
    ('60','5F5F87'),
    ('61','5F5FAF'),
    ('62','5F5FD7'),
    ('63','5F5FFF'),
    ('64','5F8700'),
    ('65','5F875F'),
    ('66','5F8787'),
    ('67','5F87AF'),
    ('68','5F87D7'),
    ('69','5F87FF'),
    ('70','5FAF00'),
    ('71','5FAF5F'),
    ('72','5FAF87'),
    ('73','5FAFAF'),
    ('74','5FAFD7'),
    ('75','5FAFFF'),
    ('76','5FD700'),
    ('77','5FD75F'),
    ('78','5FD787'),
    ('79','5FD7AF'),
    ('80','5FD7D7'),
    ('81','5FD7FF'),
    ('82','5FFF00'),
    ('83','5FFF5F'),
    ('84','5FFF87'),
    ('85','5FFFAF'),
    ('86','5FFFD7'),
    ('87','5FFFFF'),
    ('88','870000'),
    ('89','87005F'),
    ('90','870087'),
    ('91','8700AF'),
    ('92','8700D7'),
    ('93','8700FF'),
    ('94','875F00'),
    ('95','875F5F'),
    ('96','875F87'),
    ('97','875FAF'),
    ('98','875FD7'),
    ('99','875FFF'),
    ('100', '878700'),
    ('101', '87875F'),
    ('102', '878787'),
    ('103', '8787AF'),
    ('104', '8787D7'),

    # ANSI 256-only color range

    ('105', '8787FF'),
    ('106', '87AF00'),
    ('107', '87AF5F'),
    ('108', '87AF87'),
    ('109', '87AFAF'),
    ('110', '87AFD7'),
    ('111', '87AFFF'),
    ('112', '87D700'),
    ('113', '87D75F'),
    ('114', '87D787'),
    ('115', '87D7AF'),
    ('116', '87D7D7'),
    ('117', '87D7FF'),
    ('118', '87FF00'),
    ('119', '87FF5F'),
    ('120', '87FF87'),
    ('121', '87FFAF'),
    ('122', '87FFD7'),
    ('123', '87FFFF'),
    ('124', 'AF0000'),
    ('125', 'AF005F'),
    ('126', 'AF0087'),
    ('127', 'AF00AF'),
    ('128', 'AF00D7'),
    ('129', 'AF00FF'),
    ('130', 'AF5F00'),
    ('131', 'AF5F5F'),
    ('132', 'AF5F87'),
    ('133', 'AF5FAF'),
    ('134', 'AF5FD7'),
    ('135', 'AF5FFF'),
    ('136', 'AF8700'),
    ('137', 'AF875F'),
    ('138', 'AF8787'),
    ('139', 'AF87AF'),
    ('140', 'AF87D7'),
    ('141', 'AF87FF'),
    ('142', 'AFAF00'),
    ('143', 'AFAF5F'),
    ('144', 'AFAF87'),
    ('145', 'AFAFAF'),
    ('146', 'AFAFD7'),
    ('147', 'AFAFFF'),
    ('148', 'AFD700'),
    ('149', 'AFD75F'),
    ('150', 'AFD787'),
    ('151', 'AFD7AF'),
    ('152', 'AFD7D7'),
    ('153', 'AFD7FF'),
    ('154', 'AFFF00'),
    ('155', 'AFFF5F'),
    ('156', 'AFFF87'),
    ('157', 'AFFFAF'),
    ('158', 'AFFFD7'),
    ('159', 'AFFFFF'),
    ('160', 'D70000'),
    ('161', 'D7005F'),
    ('162', 'D70087'),
    ('163', 'D700AF'),
    ('164', 'D700D7'),
    ('165', 'D700FF'),
    ('166', 'D75F00'),
    ('167', 'D75F5F'),
    ('168', 'D75F87'),
    ('169', 'D75FAF'),
    ('170', 'D75FD7'),
    ('171', 'D75FFF'),
    ('172', 'D78700'),
    ('173', 'D7875F'),
    ('174', 'D78787'),
    ('175', 'D787AF'),
    ('176', 'D787D7'),
    ('177', 'D787FF'),
    ('178', 'D7AF00'),
    ('179', 'D7AF5F'),
    ('180', 'D7AF87'),
    ('181', 'D7AFAF'),
    ('182', 'D7AFD7'),
    ('183', 'D7AFFF'),
    ('184', 'D7D700'),
    ('185', 'D7D75F'),
    ('186', 'D7D787'),
    ('187', 'D7D7AF'),
    ('188', 'D7D7D7'),
    ('189', 'D7D7FF'),
    ('190', 'D7FF00'),
    ('191', 'D7FF5F'),
    ('192', 'D7FF87'),
    ('193', 'D7FFAF'),
    ('194', 'D7FFD7'),
    ('195', 'D7FFFF'),
    ('196', 'FF0000'),
    ('197', 'FF005F'),
    ('198', 'FF0087'),
    ('199', 'FF00AF'),
    ('200', 'FF00D7'),
    ('201', 'FF00FF'),
    ('202', 'FF5F00'),
    ('203', 'FF5F5F'),
    ('204', 'FF5F87'),
    ('205', 'FF5FAF'),
    ('206', 'FF5FD7'),
    ('207', 'FF5FFF'),
    ('208', 'FF8700'),
    ('209', 'FF875F'),
    ('210', 'FF8787'),
    ('211', 'FF87AF'),
    ('212', 'FF87D7'),
    ('213', 'FF87FF'),
    ('214', 'FFAF00'),
    ('215', 'FFAF5F'),
    ('216', 'FFAF87'),
    ('217', 'FFAFAF'),
    ('218', 'FFAFD7'),
    ('219', 'FFAFFF'),
    ('220', 'FFD700'),
    ('221', 'FFD75F'),
    ('222', 'FFD787'),
    ('223', 'FFD7AF'),
    ('224', 'FFD7D7'),
    ('225', 'FFD7FF'),
    ('226', 'FFFF00'),
    ('227', 'FFFF5F'),
    ('228', 'FFFF87'),
    ('229', 'FFFFAF'),
    ('230', 'FFFFD7'),
    ('231', 'FFFFFF'),

    # ANSI 256-color grayscales (last 23)

    ('232', '080808'),
    ('233', '121212'),
    ('234', '1C1C1C'),
    ('235', '262626'),
    ('236', '303030'),
    ('237', '3A3A3A'),
    ('238', '444444'),
    ('239', '4E4E4E'),
    ('240', '585858'),
    ('241', '626262'),
    ('242', '6C6C6C'),
    ('243', '767676'),
    ('244', '808080'),
    ('245', '8A8A8A'),
    ('246', '949494'),
    ('247', '9E9E9E'),
    ('248', 'A8A8A8'),
    ('249', 'B2B2B2'),
    ('250', 'BCBCBC'),
    ('251', 'C6C6C6'),
    ('252', 'D0D0D0'),
    ('253', 'DADADA'),
    ('254', 'E4E4E4'),
    ('255', 'EEEEEE')  
]

def short2rgb(short):
	for x in _T:
		if x[1] == short:
			return x[2]
	return "-1"

def rgb2short(rgb):
	for x in _T:
		if x[2] == rgb:
			return x[1]
	return "-000001"

if (__name__ == '__main__'):
	if len(sys.argv) < 2:
		print("colortrans.py: color translator, see file for documentation/licensing and access to the original main.")
		print("syntax: colortrans.py [fromrgb|torgb] [color]")
	else:
		rv = 0		
		if (sys.argv[1] == "fromrgb"):
			rv=sys.argv[2]
			print(rgb2short(sys.argv[2]))
		elif (sys.argv[1] == "torgb"):			
			rv = short2rgb(sys.argv[2])			
			print(rv)
		else:
			rv = 255
			print("unsupported command:",argv[2])
			

		




