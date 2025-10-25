<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Bài tập XSLT - Quản lý Sinh viên</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    h1 { color: #2c3e50; text-align: center; }
                    h2 { color: #34495e; border-bottom: 2px solid #3498db; padding-bottom: 5px; }
                    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #3498db; color: white; }
                    tr:nth-child(even) { background-color: #f2f2f2; }
                    .section { margin-bottom: 40px; }
                </style>
            </head>
            <body>
                <h1>BÁO CÁO QUẢN LÝ SINH VIÊN</h1>
                
                <!-- Câu 1: Liệt kê thông tin của tất cả sinh viên -->
                <div class="section">
                    <h2>1. Danh sách tất cả sinh viên</h2>
                    <table>
                        <tr>
                            <th>Mã SV</th>
                            <th>Họ tên</th>
                        </tr>
                        <xsl:apply-templates select="school/student" mode="cau1"/>
                    </table>
                </div>
                
                <!-- Câu 2: Danh sách sinh viên sắp xếp theo điểm -->
                <div class="section">
                    <h2>2. Danh sách sinh viên sắp xếp theo điểm (cao đến thấp)</h2>
                    <table>
                        <tr>
                            <th>Mã SV</th>
                            <th>Họ tên</th>
                            <th>Điểm</th>
                        </tr>
                        <xsl:apply-templates select="school/student" mode="cau2">
                            <xsl:sort select="grade" data-type="number" order="descending"/>
                        </xsl:apply-templates>
                    </table>
                </div>
                
                <!-- Câu 3: Sinh viên sinh tháng gần nhau -->
                <div class="section">
                    <h2>3. Danh sách sinh viên theo tháng sinh</h2>
                    <table>
                        <tr>
                            <th>STT</th>
                            <th>Họ tên</th>
                            <th>Ngày sinh</th>
                            <th>Tháng sinh</th>
                        </tr>
                        <xsl:apply-templates select="school/student" mode="cau3"/>
                    </table>
                </div>
                
                <!-- Câu 4: Danh sách khóa học có sinh viên học -->
                <div class="section">
                    <h2>4. Danh sách khóa học có sinh viên đăng ký</h2>
                    <table>
                        <tr>
                            <th>Mã khóa học</th>
                            <th>Tên khóa học</th>
                            <th>Số lượng SV</th>
                        </tr>
                        <xsl:apply-templates select="school/course" mode="cau4">
                            <xsl:sort select="name"/>
                        </xsl:apply-templates>
                    </table>
                </div>
                
                <!-- Câu 5: Sinh viên đăng ký khóa học "Hóa học 201" -->
                <div class="section">
                    <h2>5. Sinh viên đăng ký khóa học "Hóa học 201"</h2>
                    <table>
                        <tr>
                            <th>Mã SV</th>
                            <th>Họ tên</th>
                            <th>Ngày sinh</th>
                        </tr>
                        <xsl:apply-templates select="school/student" mode="cau5"/>
                    </table>
                </div>
                
                <!-- Câu 6: Sinh viên sinh năm 1997 -->
                <div class="section">
                    <h2>6. Danh sách sinh viên sinh năm 1997</h2>
                    <table>
                        <tr>
                            <th>Mã SV</th>
                            <th>Họ tên</th>
                            <th>Ngày sinh</th>
                        </tr>
                        <xsl:apply-templates select="school/student" mode="cau6"/>
                    </table>
                </div>
                
                <!-- Câu 7: Sinh viên họ "Trần" -->
                <div class="section">
                    <h2>7. Danh sách sinh viên họ "Trần"</h2>
                    <table>
                        <tr>
                            <th>Mã SV</th>
                            <th>Họ tên</th>
                            <th>Ngày sinh</th>
                            <th>Điểm</th>
                        </tr>
                        <xsl:apply-templates select="school/student" mode="cau7"/>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template cho câu 1: Liệt kê thông tin của tất cả sinh viên -->
    <xsl:template match="student" mode="cau1">
        <tr>
            <td><xsl:value-of select="id"/></td>
            <td><xsl:value-of select="name"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 2: Danh sách sinh viên sắp xếp theo điểm -->
    <xsl:template match="student" mode="cau2">
        <tr>
            <td><xsl:value-of select="id"/></td>
            <td><xsl:value-of select="name"/></td>
            <td><xsl:value-of select="grade"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 3: Sinh viên sinh tháng gần nhau -->
    <xsl:template match="student" mode="cau3">
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td><xsl:value-of select="name"/></td>
            <td><xsl:value-of select="date"/></td>
            <td><xsl:value-of select="substring(date, 6, 2)"/></td>
        </tr>
    </xsl:template>
    
    <!-- Template cho câu 4: Danh sách khóa học có sinh viên học -->
    <xsl:template match="course" mode="cau4">
        <xsl:variable name="courseId" select="id"/>
        <xsl:variable name="studentCount" select="count(../enrollment[courseRef = $courseId])"/>
        
        <xsl:if test="$studentCount > 0">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="$studentCount"/></td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- Template cho câu 5: Sinh viên đăng ký khóa học "Hóa học 201" -->
    <xsl:template match="student" mode="cau5">
        <xsl:variable name="studentId" select="id"/>
        <xsl:if test="../enrollment[studentRef = $studentId and courseRef = 'c3']">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="date"/></td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- Template cho câu 6: Sinh viên sinh năm 1997 -->
    <xsl:template match="student" mode="cau6">
        <xsl:if test="starts-with(date, '1997')">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="date"/></td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- Template cho câu 7: Sinh viên họ "Trần" -->
    <xsl:template match="student" mode="cau7">
        <xsl:if test="starts-with(name, 'Trần')">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="date"/></td>
                <td><xsl:value-of select="grade"/></td>
            </tr>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>