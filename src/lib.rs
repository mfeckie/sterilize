#[macro_use]
extern crate rutie;
extern crate ammonia;

use ammonia::clean;
use rutie::{Module, Object, RString, VM};

module!(Sterilize);

methods!(
    Sterilize,
    _itself,
    fn perform(input: RString) -> RString {
        let dirty_string = input.map_err(|e| VM::raise_ex(e)).unwrap().to_string();
        let sterile = clean(&dirty_string);
        RString::new_utf8(&sterile)
    }
);

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_sterilize() {
    Module::new("Sterilize").define(|itself| {
        itself.def_self("perform", perform);
    });
}
