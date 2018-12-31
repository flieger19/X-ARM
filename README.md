# X-ARM
Xcode template for embedded arm cortex-m development.

## Installation

First install the `gcc-arm-embedded` compiler:

```bash
brew cask install gcc-arm-embedded
```

Clone the repository or download `.zip` archive. 

For the basic template the [STM32 Standard Peripheral Libraries](https://www.st.com/en/embedded-software/stm32-standard-peripheral-libraries.html?querycriteria=productId=LN1939) is needed. Please extract them to a separate directory, which will be called `LIBRARY_DIR` in the following text. 
Next execute the following command:

```bash
python setup.py -L path_to_LIBRARY_DIR
```

The `setup.py` script wil install its files in `~/Library/Developer/` and the corresponding subdirectories.

## Usage

### X-ARM Basic Template

* launch Xcode
* create a new project
* under **macOS** move to **X-ARM**
* select the **X-ARM Basic** template
* click **Next**
* enter a project name 
* choose your **MCU**
* click **Finish**
* choose a directory where to save the project
* click **Create**

### X-ARM File Template

If the periphery of your cortex-m should be activated, the **X-ARM File Template** is needed. 

* while in a **X-ARM Basic**
* create a new file

**NOTE: THIS TEMPLATE IS NOT IMPLEMENTED YET**

## Future

For a future release [STM32CubeMX](https://www.st.com/content/st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-configurators-and-code-generators/stm32cubemx.html?dl=WsUg5BCPxrokFsK%2BpOHSVA%3D%3D%2CmQRYt8yKNxo%2FwAoONeoLKfw9w830P%2F7Wjgxx%2FiYethdUjXTYLxDF1iIhKXe7FBlPnTz8rQJ8ymZ%2BRrIEsapA2JbwEXnxeJp%2FIgA1feBEU0D9qR0Mv077yAHN6IJDLaueXW5qtn4sU02LRLjt5DpeYRlNRwqaSWmmtqleJG6bXVXPF7JDwzQPKJHxkSoUsWcLAs2ej7imqid4nsEe0biSwQ15iiTTmpSHr4hWHGawiM94dER%2Bn3l%2BjpOHqsU5k7q95L2eqmyL2cnj0snCSgylOL6%2Fmn7qwwsIEZkDsXIS3F2IJRmbNZweji23xNJlHHINknlrhtw4p9bLAi5cri5J%2FQ%3D%3D)  is needed.

