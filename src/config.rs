use serde::{Deserialize, Serialize};

fn default_true() -> bool {
    true
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize)]
pub struct Config {
    pub update_interval_ms: u64,
    pub show_cpu: bool,
    pub show_cpu_temp: bool,
    pub show_ram: bool,
    #[serde(default = "default_true")]
    pub show_ram_abs: bool,
    pub show_gpu: bool,
    pub show_gpu_temp: bool,
    pub show_gpu_vram: bool,
    pub show_disk: bool,
    #[serde(default = "default_true")]
    pub show_disk_abs: bool,
    pub show_net: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            update_interval_ms: 1000,
            show_cpu: true,
            show_cpu_temp: true,
            show_ram: true,
            show_ram_abs: false,
            show_gpu: false,
            show_gpu_temp: false,
            show_gpu_vram: false,
            show_disk: false,
            show_disk_abs: false,
            show_net: true,
        }
    }
}

impl Config {
    pub const VERSION: u64 = 1;

    /// Whether at least one top-level metric is enabled. The applet must always
    /// render something, otherwise it has no size and its popup cannot be opened.
    pub fn any_visible(&self) -> bool {
        self.show_cpu || self.show_ram || self.show_gpu || self.show_disk || self.show_net
    }
}
