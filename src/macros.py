# -*- coding: utf-8 -*-

import os
from rest2web.defaultmacros import default_acronyms

default_acronyms.update({
    "2ppe": "two-photons photoelectron spectroscopy",
    "aes": "Auger electron spectroscopy",
    "afm": "atomic force microscopy",
    "cvs": "chemical vapor synthesis",
    "dft": "density-functional theory",
    "drifts": "diffuse reflectance FT spectroscopy",
    "epr": "electron paramagnetic resonance",
    "fau": "Friedrich-Alexander-Universität Erlangen-Nürnberg",
    "febip": "focused electron-beam-induced processing",
    "gid": "grazing incidence diffraction",
    "gisas": "grazing incidence small angle scattering",
    "gisaxs": "grazing incidence small angle x ray scattering",
    "hopg": "highly ordered pyrolytic graphite",
    "homo": "highest occupied molecular orbital",
    "hp": "high pressure",
    "ir": "infrared",
    "iras": "infrared reflection absorption spectroscopy",
    "kpfm": "Kelvin-probe force measurement",
    "lb": "Langmuir-Blodgett",
    "leed": "low energy electron diffraction",
    "leem": "low energy electron microscopy",
    "lt": "low temperature",
    "lumo": "lowest unoccupied molecular orbital",
    "mb": "molecular beam",
    "mocvs": "metalorganic chemical vapor synthesis",
    "mssr": "metal surface selection rule",
    "nexafs": "near-edge x ray absorption fine structure",
    "peem": "photoemission electron microscopy",
    "pm": "polarization modulation",
    "por-sam": "self-assembled monolayer from porphyrins",
    "pvd": "physical vapor deposition",
    "sam": "self-assembled monolayer",
    "tem": "transmission electron microscope",
    "tof": "time-of-flight",
    "tp": "temperature-programmed",
    "tpd": "tempearture-programmed desorption",
    "tr": "time-resolved",
    "sem": "scanning electron microscopy",
    "sims": "secondary ion mass spectromety",
    "stm": "scanning tunneling microscopy",
    "sts": "scanning tunneling spectroscopy",
    "stxm": "scanning transmission x ray microscope",
    "tirs": "transmission IR spectroscopy",
    "uhv": "ultrahigh vacuum",
    "ups": "ultraviolet photoelectron spectroscopy",
    "uv": "ultraviolet",
    "xps": "x ray photoelectron spectroscopy",
    "xrd": "x ray diffraction",
    })


funcos = "<i>fun</i>COS"

def img(path, alt="", align="right"):
    return """<img src="%s" alt="%s" style="float: %s"/>""" % (
        path, alt, align)

def fig(path, title="", caption="", alt="", align="right"):
    if not alt: alt = title
    if not caption: caption = "&nbsp;"
    return os.linesep.join(
        s.strip() for s in
        """
        <div class="klein_box_rechts">
            <h2>{title}</h2>
            <img src="{path}" alt="{alt}" />
            <p>{caption}</p>
        </div>
        """.format(path=path, title=title, caption=caption, alt=alt).splitlines() if s)

