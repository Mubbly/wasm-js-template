use sub_crate::load_sub_crate;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[wasm_bindgen]
pub fn load() {
    // TODO: How to avoid symbol redefining ala. sub_crate::load() and load() would be valid
    load_sub_crate();

    log("Loaded main_crate");
}

#[wasm_bindgen]
pub fn main_crate_foo() -> i8 {
    1
}

#[cfg(test)]
mod tests {
    extern crate wasm_bindgen_test;

    use wasm_bindgen_test::*;

    use super::*;

    #[cfg_attr(not(target_arch = "wasm32"), test)]
    #[cfg_attr(target_arch = "wasm32", wasm_bindgen_test)]
    fn example_main_crate_test() {
        assert_eq!(1, main_crate_foo());
    }
}
