#pragma once
#include <string>
#include <sstream>
#include <bitset>
#if __has_include(<Vtt_um_your_design.h>)
#include <Vtt_um_your_design.h>
class tt_um_your_design_spade_t;
class tt_um_your_design_spade_t_i;
tt_um_your_design_spade_t_i* init_tt_um_your_design_spade_t_i(tt_um_your_design_spade_t& t);

class tt_um_your_design_spade_t {
    public:
        tt_um_your_design_spade_t(std::string spade_state, std::string spade_top, Vtt_um_your_design* top)
            : s_ext(spade::setup_spade(spade_top, spade_state))
            , top(top)
            , i(init_tt_um_your_design_spade_t_i(*this))
            
        {
        }
        tt_um_your_design_spade_t_i* i;
        
        rust::Box<spade::SimulationExt> s_ext;
        Vtt_um_your_design* top;
        std::string output_string_fn() {
        }
};
class tt_um_your_design_spade_t_i_clk {
    public:
        tt_um_your_design_spade_t_i_clk(tt_um_your_design_spade_t& parent)
            : parent(parent)
        {}
        tt_um_your_design_spade_t_i_clk& operator=(std::string const& val) {
            auto value = parent.s_ext->port_value("clk", val);
            parent.top->clk = value->as_u64();
            return *this;
        }
    private:
        tt_um_your_design_spade_t& parent;
};
class tt_um_your_design_spade_t_i_rst_n {
    public:
        tt_um_your_design_spade_t_i_rst_n(tt_um_your_design_spade_t& parent)
            : parent(parent)
        {}
        tt_um_your_design_spade_t_i_rst_n& operator=(std::string const& val) {
            auto value = parent.s_ext->port_value("rst_n", val);
            parent.top->rst_n = value->as_u64();
            return *this;
        }
    private:
        tt_um_your_design_spade_t& parent;
};
class tt_um_your_design_spade_t_i_ui_in {
    public:
        tt_um_your_design_spade_t_i_ui_in(tt_um_your_design_spade_t& parent)
            : parent(parent)
        {}
        tt_um_your_design_spade_t_i_ui_in& operator=(std::string const& val) {
            auto value = parent.s_ext->port_value("ui_in", val);
            parent.top->ui_in = value->as_u64();
            return *this;
        }
    private:
        tt_um_your_design_spade_t& parent;
};
class tt_um_your_design_spade_t_i_uio_in {
    public:
        tt_um_your_design_spade_t_i_uio_in(tt_um_your_design_spade_t& parent)
            : parent(parent)
        {}
        tt_um_your_design_spade_t_i_uio_in& operator=(std::string const& val) {
            auto value = parent.s_ext->port_value("uio_in", val);
            parent.top->uio_in = value->as_u64();
            return *this;
        }
    private:
        tt_um_your_design_spade_t& parent;
};
class tt_um_your_design_spade_t_i_ena {
    public:
        tt_um_your_design_spade_t_i_ena(tt_um_your_design_spade_t& parent)
            : parent(parent)
        {}
        tt_um_your_design_spade_t_i_ena& operator=(std::string const& val) {
            auto value = parent.s_ext->port_value("ena", val);
            parent.top->ena = value->as_u64();
            return *this;
        }
    private:
        tt_um_your_design_spade_t& parent;
};
class tt_um_your_design_spade_t_i {
    public:
        tt_um_your_design_spade_t_i(tt_um_your_design_spade_t& parent)
            : parent(parent)
            , clk(parent)
            , rst_n(parent)
            , ui_in(parent)
            , uio_in(parent)
            , ena(parent)
        {}
        tt_um_your_design_spade_t_i_clk clk;
        tt_um_your_design_spade_t_i_rst_n rst_n;
        tt_um_your_design_spade_t_i_ui_in ui_in;
        tt_um_your_design_spade_t_i_uio_in uio_in;
        tt_um_your_design_spade_t_i_ena ena;
    private:
        tt_um_your_design_spade_t& parent;
};
tt_um_your_design_spade_t_i* init_tt_um_your_design_spade_t_i(tt_um_your_design_spade_t& t) {
    return new tt_um_your_design_spade_t_i(t);
}

#endif