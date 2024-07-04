#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Ложь;	
	
	Настройки.Печать.ПолеСверху = 5;
	Настройки.Печать.ПолеСлева = 5;
	Настройки.Печать.ПолеСнизу = 5;
	Настройки.Печать.ПолеСправа = 5;
	Настройки.ФормироватьСразу = Ложь;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
