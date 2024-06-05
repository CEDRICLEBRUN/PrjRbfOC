from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions


options = ChromeOptions()
# print(json.dumps(options.capabilities, indent=2))

# options.add_argument("headless")
options.accept_insecure_certs = True
options.set_capability
options.add_experimental_option('excludeSwitches', ['enable-automation', 'disable-popup-blocking'])
mobile_emulation = { "deviceName": "Nexus 7" }
options.add_experimental_option("mobileEmulation", mobile_emulation)

print(options.__dict__)

# options = json.loads(chrome_options)
# driver = webdriver.Chrome(options=options)

driver = webdriver.Remote(
    command_executor='http://localhost:9515',
    options=options
)



driver.quit()