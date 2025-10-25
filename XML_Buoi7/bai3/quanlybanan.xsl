<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Bài tập XSLT - Quản lý Bàn Ăn</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    h1 { color: #2c3e50; text-align: center; }
                    h2 { color: #34495e; border-bottom: 2px solid #e74c3c; padding-bottom: 5px; }
                    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #e74c3c; color: white; }
                    tr:nth-child(even) { background-color: #f2f2f2; }
                    .section { margin-bottom: 40px; }
                    .total { font-weight: bold; background-color: #f9e79f !important; }
                </style>
            </head>
            <body>
                <h1>BÁO CÁO QUẢN LÝ BÀN ĂN</h1>
                
                <!-- Câu 1: Danh sách tất cả các bàn -->
                <div class="section">
                    <h2>1. Danh sách tất cả các bàn</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Số bàn</th>
                            <th>Tên bàn</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/BANS/BAN" mode="cau1"/>
                    </table>
                </div>
                
                <!-- Câu 2: Danh sách các nhân viên -->
                <div class="section">
                    <h2>2. Danh sách các nhân viên</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Mã NV</th>
                            <th>Tên NV</th>
                            <th>SDT</th>
                            <th>Địa chỉ</th>
                            <th>Giới tính</th>
                            <th>Username</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/NHANVIENS/NHANVIEN" mode="cau2"/>
                    </table>
                </div>
                
                <!-- Câu 3: Danh sách các món ăn -->
                <div class="section">
                    <h2>3. Danh sách các món ăn</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Mã món</th>
                            <th>Tên món</th>
                            <th>Giá</th>
                            <th>Hình ảnh</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/MONS/MON" mode="cau3"/>
                    </table>
                </div>
                
                <!-- Câu 4: Thông tin nhân viên NV02 -->
                <div class="section">
                    <h2>4. Thông tin nhân viên NV02</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Mã NV</th>
                            <th>Tên NV</th>
                            <th>SDT</th>
                            <th>Địa chỉ</th>
                            <th>Giới tính</th>
                            <th>Username</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/NHANVIENS/NHANVIEN[MANV='NV02']" mode="cau4"/>
                    </table>
                </div>
                
                <!-- Câu 5: Món ăn có giá > 50,000 -->
                <div class="section">
                    <h2>5. Danh sách món ăn có giá > 50,000</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Mã món</th>
                            <th>Tên món</th>
                            <th>Giá</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/MONS/MON[GIA > 50000]" mode="cau5"/>
                    </table>
                </div>
                
                <!-- Câu 6: Thông tin hóa đơn HD03 -->
                <div class="section">
                    <h2>6. Thông tin hóa đơn HD03</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Số HD</th>
                            <th>Nhân viên phục vụ</th>
                            <th>Số bàn</th>
                            <th>Ngày lập</th>
                            <th>Tổng tiền</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD03']" mode="cau6"/>
                    </table>
                </div>
                
                <!-- Câu 7: Tên món ăn trong hóa đơn HD02 -->
                <div class="section">
                    <h2>7. Tên món ăn trong hóa đơn HD02</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Tên món</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD02']" mode="cau7"/>
                    </table>
                </div>
                
                <!-- Câu 8: Tên nhân viên lập hóa đơn HD02 -->
                <div class="section">
                    <h2>8. Tên nhân viên lập hóa đơn HD02</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Tên nhân viên</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOHD='HD02']" mode="cau8"/>
                    </table>
                </div>
                
                <!-- Câu 9: Đếm số bàn -->
                <div class="section">
                    <h2>9. Đếm số bàn</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Tổng số bàn</th>
                        </tr>
                        <tr class="total">
                            <td>1</td>
                            <td><xsl:value-of select="count(QUANLY/BANS/BAN)"/></td>
                        </tr>
                    </table>
                </div>
                
                <!-- Câu 10: Đếm số hóa đơn lập bởi NV01 -->
                <div class="section">
                    <h2>10. Đếm số hóa đơn lập bởi NV01</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Số hóa đơn</th>
                        </tr>
                        <tr class="total">
                            <td>1</td>
                            <td><xsl:value-of select="count(QUANLY/HOADONS/HOADON[MANV='NV01'])"/></td>
                        </tr>
                    </table>
                </div>
                
                <!-- Câu 11: Món ăn từng bán cho bàn số 2 -->
                <div class="section">
                    <h2>11. Danh sách món ăn từng bán cho bàn số 2</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Tên món</th>
                            <th>Số lượng</th>
                            <th>Hóa đơn</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOBAN='2']" mode="cau11"/>
                    </table>
                </div>
                
                <!-- Câu 12: Nhân viên từng lập hóa đơn cho bàn số 3 -->
                <div class="section">
                    <h2>12. Danh sách nhân viên từng lập hóa đơn cho bàn số 3</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Tên nhân viên</th>
                            <th>Số hóa đơn</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/HOADONS/HOADON[SOBAN='3']" mode="cau12"/>
                    </table>
                </div>
                
                <!-- Câu 13: Món ăn được gọi nhiều hơn 1 lần -->
                <div class="section">
                    <h2>13. Món ăn được gọi nhiều hơn 1 lần trong các hóa đơn</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Tên món</th>
                            <th>Tổng số lượng</th>
                        </tr>
                        <xsl:apply-templates select="QUANLY/MONS/MON" mode="cau13"/>
                    </table>
                </div>
                
            </body>
        </html>
    </xsl:template>
    
    <!-- Template cho câu 1: Danh sách bàn -->
    <xsl:template match="BAN" mode="cau1">
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td><xsl:value-of select="SOBAN"/></td>
            <td><xsl:value-of select="TENBAN"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 2: Danh sách nhân viên -->
    <xsl:template match="NHANVIEN" mode="cau2">
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td><xsl:value-of select="MANV"/></td>
            <td><xsl:value-of select="TENV"/></td>
            <td><xsl:value-of select="SDT"/></td>
            <td><xsl:value-of select="DIACHI"/></td>
            <td><xsl:value-of select="GIOITINH"/></td>
            <td><xsl:value-of select="USERNAME"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 3: Danh sách món ăn -->
    <xsl:template match="MON" mode="cau3">
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td><xsl:value-of select="MAMON"/></td>
            <td><xsl:value-of select="TENMON"/></td>
            <td><xsl:value-of select="format-number(GIA, '#,##0')"/> đ</td>
            <td><xsl:value-of select="HINHANH"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 4: Thông tin NV02 -->
    <xsl:template match="NHANVIEN" mode="cau4">
        <tr>
            <td>1</td>
            <td><xsl:value-of select="MANV"/></td>
            <td><xsl:value-of select="TENV"/></td>
            <td><xsl:value-of select="SDT"/></td>
            <td><xsl:value-of select="DIACHI"/></td>
            <td><xsl:value-of select="GIOITINH"/></td>
            <td><xsl:value-of select="USERNAME"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 5: Món ăn giá > 50,000 -->
    <xsl:template match="MON" mode="cau5">
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td><xsl:value-of select="MAMON"/></td>
            <td><xsl:value-of select="TENMON"/></td>
            <td><xsl:value-of select="format-number(GIA, '#,##0')"/> đ</td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 6: Thông tin HD03 -->
    <xsl:template match="HOADON" mode="cau6">
        <tr>
            <td>1</td>
            <td><xsl:value-of select="SOHD"/></td>
            <td>
                <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV"/>
            </td>
            <td><xsl:value-of select="SOBAN"/></td>
            <td><xsl:value-of select="NGAYLAP"/></td>
            <td><xsl:value-of select="format-number(TONGTIEN, '#,##0')"/> đ</td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 7: Món ăn trong HD02 -->
    <xsl:template match="HOADON" mode="cau7">
        <xsl:for-each select="CTHDS/CTHD">
            <tr>
                <td><xsl:value-of select="position()"/></td>
                <td>
                    <xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Template cho câu 8: Nhân viên lập HD02 -->
    <xsl:template match="HOADON" mode="cau8">
        <tr>
            <td>1</td>
            <td>
                <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV"/>
            </td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 11: Món ăn bán cho bàn 2 -->
    <xsl:template match="HOADON" mode="cau11">
        <xsl:for-each select="CTHDS/CTHD">
            <tr>
                <td><xsl:value-of select="position()"/></td>
                <td>
                    <xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON"/>
                </td>
                <td><xsl:value-of select="SOLUONG"/></td>
                <td><xsl:value-of select="../../SOHD"/></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Template cho câu 12: Nhân viên lập HD cho bàn 3 -->
    <xsl:template match="HOADON" mode="cau12">
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td>
                <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV"/>
            </td>
            <td><xsl:value-of select="SOHD"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 13: Món ăn gọi nhiều hơn 1 lần -->
    <xsl:template match="MON" mode="cau13">
        <xsl:variable name="maMon" select="MAMON"/>
        <xsl:variable name="tongSoLuong" select="sum(//CTHD[MAMON=$maMon]/SOLUONG)"/>
        
        <xsl:if test="$tongSoLuong > 1">
            <tr>
                <td><xsl:value-of select="position()"/></td>
                <td><xsl:value-of select="TENMON"/></td>
                <td><xsl:value-of select="$tongSoLuong"/></td>
            </tr>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>