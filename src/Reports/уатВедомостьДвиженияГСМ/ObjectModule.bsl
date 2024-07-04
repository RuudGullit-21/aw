
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОтборПоГСМ", Ложь);
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	Коллекция = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	
	Для Каждого ЭлементНастройки Из Коллекция Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ТипЗнч(ЭлементНастройки.ПравоеЗначение) = Тип("СправочникСсылка.Номенклатура") Тогда
				ЭлементОтбора = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭлементОтбора <> Неопределено Тогда
		Если ЭлементОтбора.Использование Тогда
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОтборПоГСМ", Истина);
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ГСМ", ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
