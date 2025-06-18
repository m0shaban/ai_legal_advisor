#!/usr/bin/env python3
"""
مولد أيقونة بسيط لتطبيق المستشار القانوني الذكي
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_app_icon():
    # إنشاء أيقونة 1024x1024 (حجم أساسي)
    size = 1024
    img = Image.new('RGBA', (size, size), (30, 58, 138, 255))  # خلفية زرقاء داكنة
    draw = ImageDraw.Draw(img)
    
    # رسم دائرة خلفية فاتحة
    margin = size // 8
    circle_coords = [margin, margin, size - margin, size - margin]
    draw.ellipse(circle_coords, fill=(59, 130, 246, 255))  # أزرق متوسط
    
    # إضافة رمز العدالة (ميزان)
    center_x, center_y = size // 2, size // 2
    
    # رسم قاعدة الميزان
    base_width = size // 3
    base_height = size // 20
    base_x = center_x - base_width // 2
    base_y = center_y + size // 4
    draw.rectangle([base_x, base_y, base_x + base_width, base_y + base_height], fill=(255, 255, 255, 255))
    
    # رسم عمود الميزان
    pole_width = size // 40
    pole_height = size // 2
    pole_x = center_x - pole_width // 2
    pole_y = center_y - pole_height // 2
    draw.rectangle([pole_x, pole_y, pole_x + pole_width, pole_y + pole_height], fill=(255, 255, 255, 255))
    
    # رسم الكفتين
    plate_width = size // 6
    plate_height = size // 80
    
    # الكفة اليسرى
    left_plate_x = center_x - size // 3
    plate_y = center_y - size // 8
    draw.rectangle([left_plate_x, plate_y, left_plate_x + plate_width, plate_y + plate_height], fill=(255, 255, 255, 255))
    
    # الكفة اليمنى
    right_plate_x = center_x + size // 6
    draw.rectangle([right_plate_x, plate_y, right_plate_x + plate_width, plate_y + plate_height], fill=(255, 255, 255, 255))
    
    # رسم الخيوط
    draw.line([center_x, pole_y + size // 8, left_plate_x + plate_width // 2, plate_y], fill=(255, 255, 255, 255), width=size // 200)
    draw.line([center_x, pole_y + size // 8, right_plate_x + plate_width // 2, plate_y], fill=(255, 255, 255, 255), width=size // 200)
    
    # حفظ الصورة الأساسية
    assets_path = "assets/images"
    os.makedirs(assets_path, exist_ok=True)
    
    # حفظ الأيقونة الأساسية
    img.save(f"{assets_path}/app_icon.png", "PNG")
    
    # إنشاء نسخة للـ foreground (نفس الشكل مع خلفية شفافة)
    fg_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    fg_draw = ImageDraw.Draw(fg_img)
    
    # نسخ نفس الميزان لكن بخلفية شفافة
    # رسم دائرة خلفية فاتحة
    fg_draw.ellipse(circle_coords, fill=(59, 130, 246, 255))
    
    # إعادة رسم الميزان
    fg_draw.rectangle([base_x, base_y, base_x + base_width, base_y + base_height], fill=(255, 255, 255, 255))
    fg_draw.rectangle([pole_x, pole_y, pole_x + pole_width, pole_y + pole_height], fill=(255, 255, 255, 255))
    fg_draw.rectangle([left_plate_x, plate_y, left_plate_x + plate_width, plate_y + plate_height], fill=(255, 255, 255, 255))
    fg_draw.rectangle([right_plate_x, plate_y, right_plate_x + plate_width, plate_y + plate_height], fill=(255, 255, 255, 255))
    fg_draw.line([center_x, pole_y + size // 8, left_plate_x + plate_width // 2, plate_y], fill=(255, 255, 255, 255), width=size // 200)
    fg_draw.line([center_x, pole_y + size // 8, right_plate_x + plate_width // 2, plate_y], fill=(255, 255, 255, 255), width=size // 200)
    
    fg_img.save(f"{assets_path}/app_icon_foreground.png", "PNG")
    
    print("✅ تم إنشاء أيقونة التطبيق بنجاح!")
    print(f"📁 الملفات محفوظة في: {assets_path}/")
    print("🔄 قم بتشغيل: flutter packages pub run flutter_launcher_icons:main")

if __name__ == "__main__":
    try:
        create_app_icon()
    except ImportError:
        print("❌ يجب تثبيت مكتبة Pillow أولاً:")
        print("pip install Pillow")
