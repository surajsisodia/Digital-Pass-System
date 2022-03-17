import imp
from matplotlib.pyplot import fill
from numpy import size
import pyqrcode
import png
from pyqrcode import QRCode
from pandas import read_csv
import uuid
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont


def generate_qr(name: str, data: map) -> None:
    # Generate QR code
    print(name + " : " + uuid.uuid4().hex)
    unique_id = uuid.uuid1()
    data = {
        u'id': unique_id.hex,
        u'name': data['name'],
        u'branch': data['branch'],
        u'year': data['year'],
        u'isClaimed': False,
    }

    db = firestore.client()

    db.collection(u'passData').document(unique_id.hex).set(data)

    # url = pyqrcode.create(unique_id.hex)

    # Create and save the png file naming "myqr.png"
    # qrImg = url.png(f'qrcodes/{name}.png', scale=6)
    year = data['branch'].upper() + " ("+data['year']+")"
    createImage(name=data['name'].upper(), year=year, qrid=unique_id.hex)
    return


def operate(filename: str):
    df = read_csv(filename)
    print(df)
    for index, item in df.iterrows():
        data = {
            'name': item['NAME'],
            'branch': item['BRANCH'],
            'year': item['YEAR'],
        }
        string = item['NAME'] + '\n' + item['BRANCH'] + '\n' + item['YEAR']
        name = item['NAME'] + ' ' + item['BRANCH']
        generate_qr(name, data)
        continue
    return


def createImage(name, year, qrid):
    im = Image.new(mode="RGB", size=(400, 600), color=0xffffffff)
    logo = Image.open('logo.png')
    logo = logo.resize((100, 100))

    im.paste(logo, [150, 30])
    img_draw = ImageDraw.Draw(im)

    font = ImageFont.truetype("ProductSans.ttf", 20)
    font2 = ImageFont.truetype("ProductSansBold.ttf", 30)
    font3 = ImageFont.truetype("ProductSans.ttf", 18)

    w, h = img_draw.textsize(name, font=font)

    img_draw.text((160, 160), "Fresher's",
                  fill="black", font=font, anchor='mm')
    img_draw.text((135, 180), "MOBE 26", fill='black', font=font2, anchor='mm')
    img_draw.text(((400-w)/2, 520), name,
                  fill='black', font=font3)
    img_draw.text((150, 545), year,
                  fill='black', font=font3, anchor='mm')

    url = pyqrcode.create(qrid)
    url.png(f'testqr.png', scale=7, quiet_zone=0)
    im.paste(Image.open('testqr.png'), [85, 250])
    # im.show()

    im.save(f'digitalPass/{name}.png')


cred = credentials.Certificate(
    'ccet-digital-pass-firebase-adminsdk-fg7gh-8fed924828.json')

firebase_admin.initialize_app(cred)

operate('PAYMENT.csv')
