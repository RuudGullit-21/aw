
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	Если ЯвляетсяУдостоверениемЛичности(Запись.Физлицо, Запись.ВидДокумента, Запись.Период) Тогда
		Запись.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата)
	
	Возврат РегистрыСведений.ДокументыФизическихЛиц.ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата);
	
КонецФункции

#КонецОбласти