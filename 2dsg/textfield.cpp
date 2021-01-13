#include "textfield.h"
#include "color.h"
#include <utf8.h>
#include <application.h>

TextField::TextField(Application *application, BMFontBase* font, const char* text, const char* sample, FontBase::TextLayoutParameters *params) : TextFieldBase(application)
{
	if (text) {
		text_ = text;
	}

	font_ = font;
	if (font_ != 0)
		font_->ref();


    sminx = 0, sminy = 0, smaxx = 0, smaxy = 0;

	if (sample)
		setSample(sample);

	if (params)
        layout_=*params;

    setTextColor(0xFF000000);
}

/*
Font* TextField::font()
{
    return font_;
}
*/

void TextField::setFont(FontBase *font)
{
    if (font->getType() == FontBase::eTTFont) return;

    if (font_ == font) return;

	if (font != 0)
		font->ref();
	if (font_ != 0)
		font_->unref();
    font_ = static_cast<BMFontBase*>(font);

	createGraphics();
}

void TextField::setText(const char* text)
{
	if (strcmp(text, text_.c_str()) == 0)
		return;

	text_ = text;

	createGraphics();
}

const char* TextField::text() const
{
	return text_.c_str();
}

void TextField::extraBounds(float* minx, float* miny, float* maxx, float* maxy) const
{
    if (minx)
        *minx = minx_;

    if (miny)
        *miny = miny_;

    if (maxx)
        *maxx = maxx_;

    if (maxy)
        *maxy = maxy_;
}

void TextField::setTextColor(unsigned int color)
{
	textColor_ = color;

	int a = (color >> 24) & 0xff;
	int r = (color >> 16) & 0xff;
	int g = (color >> 8) & 0xff;
	int b = color & 0xff;

	a_ = a / 255.f;
	r_ = r / 255.f;
	g_ = g / 255.f;
	b_ = b / 255.f;

	createGraphics();
}

unsigned int TextField::textColor() const
{
	return textColor_;
}

void TextField::setLetterSpacing(float letterSpacing)
{
	layout_.letterSpacing = letterSpacing;
	
	createGraphics();
}

float TextField::letterSpacing() const
{
    return layout_.letterSpacing;
}

float TextField::lineHeight() const
{
    return smaxy - sminy;
}

void TextField::setSample(const char* sample)
{
    sample_ = sample;

    if (sample_.empty()) {
        sminx = sminy = smaxx = smaxy = 0;
        createGraphics();
        return;
    }

    graphicsBase_.clear();

    FontBase::TextLayoutParameters empty;
    FontBase::TextLayout l;
    font_->drawText(&graphicsBase_, sample, r_, g_, b_, a_, &empty, false, 0, 0, l);
    float minx, miny, maxx, maxy;
    minx = 1e30;    miny = 1e30;    maxx = -1e30;    maxy = -1e30;
	for (std::vector<GraphicsBase>::iterator it=graphicsBase_.begin();it!=graphicsBase_.end();it++)
	{
		float lminx_, lminy_, lmaxx_, lmaxy_;
		(*it).getBounds(&lminx_, &lminy_, &lmaxx_, &lmaxy_);
		minx = std::min(minx, lminx_);
		miny = std::min(miny, lminy_);
		maxx = std::max(maxx, lmaxx_);
		maxy = std::max(maxy, lmaxy_);
	}

    sminx = (int) minx;
    sminy = (int) miny;
    smaxx = (int) maxx;
    smaxy = (int) maxy;

    createGraphics();
}

const char* TextField::sample() const
{
    return sample_.c_str();
}

#define FDIF_EPSILON 0.01 //This assumes that logical space coordinates is similar to pixel space, which may not be true at all
#define FDIF(a,b) (((a>b)?(a-b):(b-a))>FDIF_EPSILON)
void TextField::createGraphics()
{
	scaleChanged(); //Mark current scale as graphics scale
    graphicsBase_.clear();
    bool layoutSizeChanged=false;
	float lmw=textlayout_.mw;
	float lbh=textlayout_.bh;
	float lw=textlayout_.w;
	float lh=textlayout_.h;
    if (font_ != NULL)
        font_->drawText(&graphicsBase_, text_.c_str(), r_, g_, b_, a_, &layout_, !sample_.empty(), sminx, sminy, textlayout_);
    else
    	textlayout_=font_->layoutText("", &layout_);
    layoutSizeChanged=FDIF(textlayout_.mw,lmw)||FDIF(textlayout_.bh,lbh)||FDIF(textlayout_.h,lh)||FDIF(textlayout_.w,lw);

    minx_ = 1e30;    miny_ = 1e30;    maxx_ = -1e30;    maxy_ = -1e30;
	for (std::vector<GraphicsBase>::iterator it=graphicsBase_.begin();it!=graphicsBase_.end();it++)
	{
		float lminx_, lminy_, lmaxx_, lmaxy_;
		(*it).getBounds(&lminx_, &lminy_, &lmaxx_, &lmaxy_);
		minx_ = std::min(minx_, lminx_);
		miny_ = std::min(miny_, lminy_);
		maxx_ = std::max(maxx_, lmaxx_);
		maxy_ = std::max(maxy_, lmaxy_);
	}
	if (layoutSizeChanged) layoutSizesChanged();
}

void TextField::doDraw(const CurrentTransform&, float sx, float sy, float ex, float ey)
{
    G_UNUSED(sx);
    G_UNUSED(sy);
    G_UNUSED(ex);
    G_UNUSED(ey);
    if (scaleChanged()) createGraphics();
    if (font_ != NULL)
        font_->preDraw();
	for (std::vector<GraphicsBase>::iterator it=graphicsBase_.begin();it!=graphicsBase_.end();it++)
		(*it).draw(getShader((*it).getShaderType()));
}

void TextField::setLayout(FontBase::TextLayoutParameters *l)
{
	if (l)
	{
		layout_=*l;
		createGraphics();
	}
}
