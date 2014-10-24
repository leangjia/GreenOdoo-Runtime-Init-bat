GreenOdoo-Runtime-Init-bat
==========================

步科ODOO绿色版运行环境，数据库目录初始化脚本

方便多个源代码共享一个运行环境


使用方法：
把env.bat和setup.bat复制到准备用于postgresql数据库的目录
修改env.bat设置步科ODOO绿色版运行环境目录和odoo源代码目录
例如：
    set RUNTIME_DIR=E:\github\GreenOdoo-Runtime
    set OE_SRC_DIR=E:\github\odoo
运行setup.bat按提示输入Y确认，成功后在setup.bat目录下会生成：
data目录       这是数据库数据目录
runtime目录    这是odoo执行脚本
logfile        这是数据库日志

可以进入runtime目录手动调整openerp-server.conf文件
执行runtime目录下start.bat可以启动pg数据库和OE
执行runtime目录下stop.bat可以停止oe和pg数据库