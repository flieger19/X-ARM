# X-ARM
Xcode template for embedded arm cortex-m development.

## Supported Microcontrollers

* STM32F446XX

## Installation

First install the `gcc-arm-embedded` compiler:

```bash
brew cask install gcc-arm-embedded
```

For productive work I recommend tu use [STM32CubeMX](https://www.st.com/content/st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-configurators-and-code-generators/stm32cubemx.html?dl=WsUg5BCPxrokFsK%2BpOHSVA%3D%3D%2CmQRYt8yKNxo%2FwAoONeoLKfw9w830P%2F7Wjgxx%2FiYethdUjXTYLxDF1iIhKXe7FBlPnTz8rQJ8ymZ%2BRrIEsapA2JbwEXnxeJp%2FIgA1feBEU0D9qR0Mv077yAHN6IJDLaueXW5qtn4sU02LRLjt5DpeYRlNRwqaSWmmtqleJG6bXVXPF7JDwzQPKJHxkSoUsWcLAs2ej7imqid4nsEe0biSwQ15iiTTmpSHr4hWHGawiM94dER%2Bn3l%2BjpOHqsU5k7q95L2eqmyL2cnj0snCSgylOL6%2Fmn7qwwsIEZkDsXIS3F2IJRmbNZweji23xNJlHHINknlrhtw4p9bLAi5cri5J%2FQ%3D%3D) 

Clone the repository or download `.zip` archive. 

Next execute the following command:

```bash
python3 package.py
```

The `package.py` script wil install its files in `~/Library/Developer/` and the corresponding subdirectories.

## Usage

### STM32CubeMX Template

Start with a new Xcode Project:
* launch Xcode
* create a new project
* under **Multiplatform** move to **X-ARM**
* select the **STM32CubeMX** template
* click **Next**
* enter a project name 
* choose your **MCU**
* click **Finish**
* choose a directory where to save the project
* click **Create**

Add STM32CubeMX project tot he previously create Xcode project:
* launch STM32CubeMX
* create a new project with one of the supported microcontrollers
* Save the project insight the previously created Xcode project 
* Run the code generation for a makefile project

Add the generated files to the Xcode project
* Add all generated source files including the make and linker file to the Xcode project
* Add all source files to the Build Phase settings Compile Sources of the Index target
* Build the Index target.

You should now be able to use the Xcode project as usual.

**NOTE:** This template has now debugging function. To debug please use `st-util` in combination with the `arm-none-eabi-gdb` or `lldb`
