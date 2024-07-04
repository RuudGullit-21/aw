
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ВидЭлемента") Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтотОбъект);
	Заголовок = Параметры.ВидЭлемента;
	
	Если ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистраБухгалтерии Тогда
		Элементы.ИмяИзмерения.СписокВыбора.Очистить();
		Элементы.ИмяИзмерения.СписокВыбора.Добавить("Организация","Организация");
		Элементы.ИмяИзмерения.СписокВыбора.Добавить("Подразделение","Подразделение");
		Элементы.ИмяИзмерения.РедактированиеТекста = Ложь;
	ИначеЕсли ТипИзмерения = Перечисления.ТипыИзмеренийФинансовогоОтчета.Субконто Тогда
		Элементы.ИмяИзмерения.Видимость = Ложь;
		Элементы.ВидСубконто.Видимость = Истина;
		Элементы.ВидСубконто.ОграничениеТипа = ФинансоваяОтчетностьСервер.ОписаниеТипаПоЗначению(ВидСубконто);
	Иначе
		МодельБюджетирования = Параметры.МодельБюджетирования;
		
		Если ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоПодразделениям", 
				Новый Структура("МодельБюджетирования", МодельБюджетирования)) Тогда
			Элементы.ИмяИзмерения.СписокВыбора.Вставить(0, "Подразделение");
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоОрганизациям", 
				Новый Структура("МодельБюджетирования", МодельБюджетирования)) Тогда
			Элементы.ИмяИзмерения.СписокВыбора.Вставить(0, "Организация");
		КонецЕсли;
		
		Элементы.ГруппаДополнительныйОтбор.Видимость = Ложь;
	КонецЕсли;
	
	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяИзмеренияПриИзменении(Элемент)
	
	Объект.НаименованиеДляПечати = Элементы.ИмяИзмерения.СписокВыбора.НайтиПоЗначению(ИмяИзмерения).Представление;
	Если ТипИзмерения = 
		ПредопределенноеЗначение("Перечисление.ТипыИзмеренийФинансовогоОтчета.ИзмерениеРегистраБухгалтерии") Тогда
		НастроитьПолеОтбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСубконтоПриИзменении(Элемент)
	
	ВидСубконтоПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВидСубконтоПриИзмененииСервер()
	
	Объект.НаименованиеДляПечати = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидСубконто, "Наименование");
	НастроитьПолеОтбора();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПолеОтбора()
	
	Справочники.ЭлементыФинансовыхОтчетов.УстановитьНастройкиОтбора(ЭтотОбъект, ЭтотОбъект.Компоновщик, Объект.ВидЭлемента, Компоновщик.Настройки);
	
КонецПроцедуры

#КонецОбласти
