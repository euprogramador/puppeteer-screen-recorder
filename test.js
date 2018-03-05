const puppeteer = require('puppeteer');
const sleep = require('sleep');

(async () => {
  const browser = await puppeteer.launch({
    ignoreHTTPSErrors: true,
    headless: false,
    slowMo: 50,
    width: 1280,
    height: 860,
    args: [
      '--window-position=0,0',
      '--window-size=1336,768',
      '--disable-infobars'
    ],
  });

  const page = await browser.newPage();
  page.setViewport({ width: 1336, height: 768 })

  await page.goto('http://www.capes.gov.br');
  await page.type('#portal-searchbox-field', 'Headless Chrome');
  await page.keyboard.press('Enter');
  await page.waitForSelector(".documentFirstHeading");
  await page.click("#area-contenttags");

  await page.$eval('#search-searchword', el => el.value='');
  await page.type('#search-searchword', 'no headless Chrome');

  await page.click('#searchForm > div > div.span3 > p > button');

  sleep.sleep(3);

  await browser.close();
})();

