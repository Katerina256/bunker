from os import walk, path, unlink
import sys
from PIL import Image

import pytesseract
from pyzbar.pyzbar import decode
from pydub import AudioSegment
import requests
import shutil

files = next(walk('./resource/card'), (None, None, []))[2]

files = sorted(files)


def recognize(img, f_name):
  # thresh = 180
  def fn(x): return 0 if x > thresh else 255

  # img_seed = img.convert('L').point(fn, mode='1')

  # d = decode(img_seed)
  # if d:
  #   return d[0].data.decode('utf-8')

  thresh = 160
  img_seed = img.convert('L').point(fn, mode='1')
  img_seed.save(path.join('./resource/qr', f_name))

  d = decode(img_seed)
  if d:
    return d[0].data.decode('utf-8')

  # thresh = 160
  # img_seed = img.convert('L').point(fn, mode='1')

  # d = decode(img_seed)
  # if d:
  #   return d[0].data.decode('utf-8')

  return None


def main():
  print('start parsing...')

  for f in files:
    print(f)

    img = Image.open(path.join('./resource/card', f))
    width, height = img.size

    if width > height:
      img = img.transpose(Image.ROTATE_270)

    img = img.crop((0, 3100, 800, 4000))

    qr_link = recognize(img, f)
    with open(path.join('./resource/link', f.replace('.jpg', '.txt')), 'w') as txt:
      txt.write(qr_link)

    r = requests.get(qr_link, allow_redirects=False)
    url = r.headers['Location']
    url = url.replace('https://www.dropbox.com',
                      'https://dl.dropboxusercontent.com')
    print(url)

    response = requests.get(url, stream=True)
    with open('./.temp', 'wb') as out_file:
      shutil.copyfileobj(response.raw, out_file)
    del response

    audio = AudioSegment.from_file('./.temp', 'm4a')
    audio.export(
        path.join('./resource/audio', f.replace('.jpg', '.mp3')),
        format="mp3"
    )

    unlink('./.temp')
  print('parsing done...')


def tes():
  print('start tesseract...')

  for f in files:
    print(f)

    img = Image.open(path.join('./resource/card', f))
    width, height = img.size

    if width > height:
      img = img.transpose(Image.ROTATE_270)

    img = img.crop((0, 680, 3000, 3200))

    thresh = 130
    def fn(x): return 255 if x > thresh else 0
    img = img.convert('L').point(fn, mode='1')
    img.save('test.png', 'PNG')

    img.load()

    text = pytesseract.image_to_string(img, lang="rus")

    with open(path.join('./resource/text', f.replace('.jpg', '.txt')), 'w') as txt:
      txt.write(text)
    # break
  print('tesseract done...')


# tes()
# main()
