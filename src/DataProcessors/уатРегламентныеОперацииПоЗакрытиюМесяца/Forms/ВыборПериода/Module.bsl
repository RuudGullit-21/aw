
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Значение", ВыбираемыйПериод);
	
	КлючСохраненияПоложенияОкна = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "КлючСохраненияПоложенияОкна", "ОдинПериод");
	
	Если НЕ ЗначениеЗаполнено(ВыбираемыйПериод) Тогда
		ВыбираемыйПериод = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	УстановитьРежимВыбораПериода(ЭтаФорма, Параметры.РежимВыбораПериода);
	
	ЦветФонаКнопкиВыбранногоПериода = ЦветаСтиля.ФонУправляющегоПоля;
	ЦветФонаКнопки                  = ЦветаСтиля.ЦветФонаКнопки;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьОтображение();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбираемыйПериодПриИзменении(Элемент)
	
	ИзменилсяГод = Истина;
	ОтмеченныйПериод = Неопределено;
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), Месяц(ВыбираемыйПериод));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаМесяц01(Команда)
	УстановитьВыбираемыйМесяц(1);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц02(Команда)
	УстановитьВыбираемыйМесяц(2);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц03(Команда)
	УстановитьВыбираемыйМесяц(3);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц04(Команда)
	УстановитьВыбираемыйМесяц(4);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц05(Команда)
	УстановитьВыбираемыйМесяц(5);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц06(Команда)
	УстановитьВыбираемыйМесяц(6);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц07(Команда)
	УстановитьВыбираемыйМесяц(7);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц08(Команда)
	УстановитьВыбираемыйМесяц(8);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц09(Команда)
	УстановитьВыбираемыйМесяц(9);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц10(Команда)
	УстановитьВыбираемыйМесяц(10);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц11(Команда)
	УстановитьВыбираемыйМесяц(11);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц12(Команда)
	УстановитьВыбираемыйМесяц(12);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	ВыполнитьВыбор();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПролистатьГодВМинус(Команда)
	
	ВыбираемыйГод = Год(ВыбираемыйПериод) - 1;
	ОтмеченныйПериод = Неопределено;
	УстановитьВыбираемыйПериод(ВыбираемыйГод, Месяц(ВыбираемыйПериод));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПролистатьГодВПлюс(Команда)
	
	ВыбираемыйГод = Год(ВыбираемыйПериод) + 1;
	ОтмеченныйПериод = Неопределено;
	УстановитьВыбираемыйПериод(ВыбираемыйГод, Месяц(ВыбираемыйПериод));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВыбираемыйМесяц(НомерМесяца)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), НомерМесяца, "МЕСЯЦ");
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРежимВыбораПериода(Форма, Знач РежимВыбора)
	
	Если НЕ ЗначениеЗаполнено(РежимВыбора) Тогда
		РежимВыбора = "Месяц";
	КонецЕсли; 
	
	Если Форма.РежимВыбораПериода = ВРег(РежимВыбора) Тогда
		Возврат;
	КонецЕсли; 
	
	Форма.РежимВыбораПериода = ВРег(РежимВыбора);
		
	Форма.ВыбираемыйПериод = НачалоМесяца(Форма.ВыбираемыйПериод);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНевыбранныйЦветКнопок()

	Если РежимВыбораПериода = "МЕСЯЦ" Тогда
		ЧислоКнопок = 12;
		ПрефиксКоманды = "КомандаМесяц";
	ИначеЕсли РежимВыбораПериода = "КВАРТАЛ" Тогда
		ЧислоКнопок = 4;
		ПрефиксКоманды = "КомандаКвартал";
	ИначеЕсли РежимВыбораПериода = "ПОЛУГОДИЕ" Тогда
		ЧислоКнопок = 2;
		ПрефиксКоманды = "КомандаПолугодие";
	Иначе
		ЧислоКнопок = 1;
		ПрефиксКоманды = "КомандаГод";
	КонецЕсли;

	Для НомерПоПорядку = 1 По ЧислоКнопок Цикл
		Если РежимВыбораПериода = "ГОД" Тогда
			ЭлементКнопка = Элементы[ПрефиксКоманды];
		Иначе
			ФорматнаяСтрока = ?(РежимВыбораПериода = "МЕСЯЦ", "ЧЦ=2; ЧВН=", "ЧЦ=1");
			ЭлементКнопка = Элементы[ПрефиксКоманды + Формат(НомерПоПорядку, ФорматнаяСтрока)];
		КонецЕсли;
		
		Если ЭлементКнопка.ЦветФона <> ЦветФонаКнопки Тогда
			ЭлементКнопка.ЦветФона = ЦветФонаКнопки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображение()
	
	КнопкаМесяца = Элементы["КомандаМесяц" + Формат(Месяц(ВыбираемыйПериод), "ЧЦ=2; ЧВН=")];
	Если КнопкаМесяца.ЦветФона <> ЦветФонаКнопкиВыбранногоПериода Тогда
		КнопкаМесяца.ЦветФона = ЦветФонаКнопкиВыбранногоПериода;
	КонецЕсли;
	
	ЭтаФорма.ТекущийЭлемент = КнопкаМесяца;
	ПериодСтрокой = Формат(ВыбираемыйПериод, "ДФ='ММММ гггг'");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбираемыйПериод(Год, Месяц, РежимВыбора = "")
	
	Если ОтмеченныйПериод = Дата(Год, Месяц, 1)
		И НЕ ИзменилсяГод 
		И РежимВыбораПериода = РежимВыбора Тогда
		
		ВыполнитьВыбор();
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(РежимВыбора) Тогда
		УстановитьНевыбранныйЦветКнопок();
		РежимВыбораПериода = РежимВыбора;
	КонецЕсли;
	
	Если Год < 1 Тогда
		Год = 1;
	КонецЕсли; 
	
	ИзменилсяГод = Ложь;
	ВыбираемыйПериод = Дата(Год, Месяц, 1);
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбор()
	
	Закрыть(ВыбираемыйПериод);
	
КонецПроцедуры

#КонецОбласти
